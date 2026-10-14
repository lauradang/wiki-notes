# Disaggregated Inference (Prefill/Decode)

**Disaggregated inference** splits serving into separate **prefill** and **decode** engines on different GPUs, with a coordinator routing each request prefill → decode and the KV cache handed off between them (Megatron `DynamicInferenceEngine`).

> Running example: **4 GPUs**, **1 rank = 1 GPU** (GPUs 1–4 = ranks 0–3), model has **8 KV heads / layer**.

## Launch + shard resolution

```
--inference-shards  "tp=2, role=prefill"  +  "tp=1, dp=2, role=decode"
        ⇒ List[InferenceShardSpec]   (2 shards: 1 prefill, 1 decode)
```

```
        Prefill shard (tp=2, dp=1)                 Decode shard (tp=1, dp=2)
 ┌──────────────────┬──────────────────┐   ┌──────────────────┬──────────────────┐
 │ GPU 1            │ GPU 2            │   │ GPU 3            │ GPU 4            │
 │ model ½ weight   │ model ²⁄₂ weight │   │ model copy 1     │ model copy 2     │
 │ KV heads 0–3     │ KV heads 4–7     │   │ KV heads 0–7     │ KV heads 0–7     │
 │ prefill-s0-dp0   │ prefill-s0-dp0   │   │ decode-s1-dp0    │ decode-s1-dp1    │
 │ TP rank 0  ✓     │ TP rank 1  ✗     │   │ TP rank 0  ✓     │ TP rank 0  ✓     │
 └──────────────────┴──────────────────┘   └──────────────────┴──────────────────┘
                                            ✓ = MP coordinator (runs the engine loop)
```

- **PP** = split model by layers · **TP** = split each layer's weights
- `TP × PP` (= 1 model copy) `× DP` (= # of copies) `= num_gpus`

| Process group collection (PGC) | Groups |
|---|---|
| Prefill shard | TP = GPU 1 + GPU 2 |
| Decode shard  | DP = GPU 3 + GPU 4 |

e.g. on rank 0 (GPU 1): `InferenceShard = [GPU 1's PGC, None]` — decode PGC thrown away since GPU 1 is prefill.

### How models are built on each GPU

1. **Create the model's layers** (no weights yet) → reads PGC to know how to split
   - GPU 1, 2 make ½-size layers · GPU 3, 4 make full-size
2. **Load weights from ckpt**
   - GPU 1 reads 1st half of each weight · GPU 2 reads 2nd half

## Config requirements

- prefix caching
- disagg shards (≥1 prefill, ≥1 decode)
- `use-coord = True`

## KV transfer setup

- **One head** = a single attention computation: `softmax(QKᵀ / √d) · V`
- **NIXL** = decode **reads** directly from prefill's memory (pull)
- **NCCL** = prefill **sends** data to decode (push)

## Engine startup (`DynamicInferenceEngine`)

`start_listening_to_data_parallel_coordinator`:

```
if engine is mp_coordinator (tp rank == 0):
    if disagg ON:
        send REGISTER_ROLE
```

**Which GPU is the MP coordinator?**

| GPU | TP rank | MP coord? |
|---|---|---|
| 1 | 0 | ✓ `prefill-s0-dp0` |
| 2 | 1 | ✗ follows GPU 1 |
| 3 | 0 | ✓ `decode-s1-dp0` |
| 4 | 0 | ✓ `decode-s1-dp1` |

Then:

1. **Start coordinator process** → in disagg, **global rank 0** starts it
2. **Connection** between coordinator ↔ ranks established
3. **`schedule_requests`** → listens for incoming requests

## Client → coordinator message

`InferenceClient.add_request` → `Message` → coordinator (`handle_submit_request`)

| Frame | Contents | Coordinator reads it? |
|---|---|---|
| 0 | header, req id, sampling params, media descriptor | ✓ |
| 1 | prompt tokens | ✗ straight to engine |
| 2 | block hashes | ✓ chooses engine, then discards |
| 3 | media bytes | ✗ straight to engine |
| 4 | offload params | ✗ straight to engine |

> Block hashes: prompt tokens (`"hi"`, `"I"`, …) are chunked into KV blocks; one hash per block.

## Request lifecycle

### Coordinator routing (prefill → decode handoff)

```mermaid
sequenceDiagram
    participant C as Client
    participant Co as Coordinator
    participant P as Prefill engine<br/>(prefill-s0-dp0)
    participant D as Decode engine<br/>(decode-s1-dp1)

    C->>Co: SUBMIT_REQUEST
    Note over Co: _select_engine<br/>picks prefill engine based on load
    Co->>P: SUBMIT_REQUEST
    Note over Co: request added to hop1_request_ids<br/>(= "it's in prefill")
    Note over P: prefill done →<br/>① pins KV blocks<br/>② attaches disagg params to request
    P->>Co: ENGINE_REPLY
    Note over Co: handle_prefill_done<br/>• _select_engine picks decode engine<br/>• discard from hop1_request_ids
    Co->>D: SUBMIT_REQUEST_WITH_KV
```

### Full lifecycle across GPUs

```mermaid
sequenceDiagram
    participant C as Client
    participant Co as Coordinator<br/>(rank 0 / GPU 1)
    participant G1 as GPU 1<br/>prefill TP0 (heads 0–3)
    participant G2 as GPU 2<br/>prefill TP1 (heads 4–7)
    participant D as GPU 3/4<br/>decode-s1-dp1

    C->>Co: request
    Co->>G1: prefill-s0-dp0
    Note over G1,G2: request runs on both GPUs,<br/>each on ½ of its heads
    G1->>Co: ENGINE_REPLY (only GPU 1 replies)
    Co->>D: SUBMIT_REQUEST_WITH_KV
    Note over D: ① check own prefix cache →<br/>only copy blocks it doesn't have<br/>② reserve space for blocks + tokens to gen
    D-->>G1: ③ NIXL read heads 0–3
    D-->>G2: ③ NIXL read heads 4–7
    D->>Co: ④ KV_READ_DONE
    Co->>G1: ⑤ RELEASE_KV
    G1->>G2: ⑥ tell GPU 2 to release KV
    Note over D: ⑦ generation in progress → done
    D->>Co: ENGINE_REPLY
    Co->>C: ⑧ done
```

## Original handwritten notes

![Launch + shard resolution](images/disagg-launch-shards.jpg)

![Config reqs, KV transfer, client → coordinator](images/disagg-config-client.jpg)

![Engine startup + request lifecycle](images/disagg-engine-lifecycle.jpg)

## Related
- `Machine_Learning/LLMs/Inference/prefill-decode.md` — the prefill vs decode phases this architecture splits apart
- `Work/LLM/nemo-rl-architecture.md` — NeMo-RL uses Megatron inference engines for rollouts
- `Work/LLM/async-grpo-refit-drain.md` — engine drain/refit interacts with in-flight requests
