# Megatron P/D Behind Dynamo

**Megatron P/D behind Dynamo** is the NeMo-RL setup where generation is split into **prefill** model copies (read the prompt, build the KV cache) and **decode** model copies (generate tokens from that KV cache). All of them are NeMo-RL's own Megatron inference engines, and the **Dynamo frontend** routes each request across both. Introduced by the stack starting at NVIDIA-NeMo/RL#4801.

## The terms, nested

```
Dynamo worker                    ← Dynamo's word for "one complete copy of the model"
│                                  (e.g. 4 GPUs at TP=4)
├── sidecar                      ← 1 CPU Ray actor; starts the adapter process
│     └── adapter process        ← Megatron-LM code; registers with Dynamo, receives requests
│
├── Megatron worker  (GPU 0)     ← 1 Python process on 1 GPU
│     ├── Megatron engine        ← 1 object inside that process
│     └── coordinator            ← only on GPU 0; makes all GPUs step together
├── Megatron worker  (GPU 1)
│     └── Megatron engine
├── Megatron worker  (GPU 2)
│     └── Megatron engine
└── Megatron worker  (GPU 3)
      └── Megatron engine
```

| Term | What it physically is | Defined by |
|---|---|---|
| **Ray worker** | Any process Ray starts and manages (generic Ray word) | Ray |
| **Megatron worker** | A Ray worker on **one GPU**: loads that GPU's slice of the model, receives new weights, takes "generate" commands. Class `MegatronPolicyWorker` | NeMo-RL |
| **Megatron engine** | An **object inside** a Megatron worker: `DynamicInferenceEngine`. Schedules requests, owns the KV cache, runs the forward pass. Always 1:1 with its Megatron worker | Megatron-LM |
| **Coordinator** | Loop on GPU 0 of a model copy: takes requests and makes all its engines step together | Megatron-LM |
| **Sidecar** | CPU-only Ray actor (`DynamoMegatronAdapterActor`) that starts the adapter process with `Popen` | NeMo-RL |
| **Adapter process** | `python -m megatron.inference.integrations.dynamo`. **Not** a Ray worker. Registers the model copy with Dynamo and forwards requests to the coordinator | Megatron-LM |
| **Dynamo worker** | **Not a process.** A registration in Dynamo's registry (etcd/NATS) meaning "one complete model copy you can send requests to". Made up of TP×PP Megatron workers + 1 sidecar + 1 adapter process | Dynamo |
| **Replica** | A **planning unit**, not a runtime object: a fixed bundle of prefill + decode Dynamo workers (e.g. 1P + 2D) | NeMo-RL config |

- **Megatron worker vs. Megatron engine:** the worker is the **process** (the box on the GPU). The engine is the **inference machinery inside it**. The worker also does things the engine doesn't, like the refit.
- **"Engine" in NeMo-RL Dynamo config usually means a Dynamo worker, not a Megatron engine:**

| Name in code | Actually means |
|---|---|
| `num_prefill_engines` / `num_decode_engines` | prefill / decode **Dynamo workers per replica** |
| `engine_world_size`, `engine_widths` | **GPUs (Megatron workers) in one Dynamo worker** |
| `dynamo_cfg.prefill_engines` / `decode_engines` | one TP/PP layout per prefill / decode **Dynamo worker** of a replica |
| `dynamo_cfg.engine: vllm \| megatron` | **which software** the Dynamo workers run |
| `workers_per_shard` (refit code) | Megatron workers per Dynamo worker ("shard" = Dynamo worker) |
| `DynamicInferenceEngine` | the real Megatron engine |

- **"Replica" elsewhere:** Megatron-LM's adapter README uses "model replica" for **one Dynamo worker**. In NeMo-RL's P/D config, "replica" means the **P/D group**.

## Width

**Width = GPUs (Megatron workers) in one Dynamo worker = TP × PP × CP**

| Term | What it splits | Effect on width |
|---|---|---|
| TP (tensor parallel) | Each layer's matrices are cut into TP slices, one per GPU | ×TP |
| PP (pipeline parallel) | Layers are cut into PP stages | ×PP |
| CP (context parallel) | One long sequence is split across GPUs | always 1 for inference |
| EP / ETP (MoE experts) | Experts spread over **the same** GPUs | ×1, but ETP×EP×PP must divide the width |
| DP (data parallel) | Number of complete model copies = number of Dynamo workers | not part of width |

- **Per-worker layouts:** every Dynamo worker may have its own width, even two decode workers in the same replica. On each handoff, Megatron-LM rebuilds the source layout from the request's metadata and `kv_reshard` re-cuts the KV cache (e.g. 4 TP slices → 2). Only head_dim, KV block size and dtype must match.
- **vLLM:** vLLM 0.29 itself supports different TP on the prefill and decode sides (NIXL connector, dense and MoE; not Mamba hybrids; no PP > 1 on decode in push mode). NeMo-RL's managed vLLM fleet still runs one `vllm_cfg` layout everywhere, so the per-worker lists are Megatron-only for now.
- **Layout precedence:** `policy.megatron_cfg` (the trainer's) → `mcore_generation_config` → the Dynamo worker's entry in `prefill_engines` / `decode_engines`. Each entry must give both TP and PP; everything else (EP, precision) comes from the shared layout.
- **List rules:** an empty list (the default) means every Dynamo worker of that role uses the shared layout. A non-empty list must have exactly `num_prefill_engines` (`num_decode_engines`) entries. Entry *k* is the *k*-th worker of that role in **every** replica.
- **Replica width** = P·w_p + D·w_d. The inference GPU count must be a multiple of it.

## Example config (24 GPUs)

```yaml
defaults: grpo_math_1B_dynamo_pd_megatron_single_controller.yaml

cluster:                      # every GPU in the job
  num_nodes: 3                #   3 nodes x 8 = 24 GPUs
  gpus_per_node: 8

policy:
  model_name: Qwen/Qwen3-8B
  megatron_cfg:               # TRAINER layout (gets whatever generation doesn't take)
    tensor_model_parallel_size: 2   # 8 trainer GPUs / TP 2 = 4 data-parallel copies
    pipeline_model_parallel_size: 1

  generation:
    backend: dynamo
    dynamo_cfg:
      engine: megatron        # Dynamo workers run Megatron (not vLLM)
      prefill_engines:        # one entry per PREFILL Dynamo worker of a replica
        - tensor_model_parallel_size: 4     # -> width 4
          pipeline_model_parallel_size: 1
      decode_engines:         # one entry per DECODE Dynamo worker of a replica
        - tensor_model_parallel_size: 2     # -> width 2
          pipeline_model_parallel_size: 1
        - tensor_model_parallel_size: 2     # -> width 2 (could differ, e.g. TP 1 x PP 2)
          pipeline_model_parallel_size: 1
    disaggregation:           # what ONE replica contains
      enabled: true
      num_prefill_engines: 1  #   1 prefill Dynamo worker  (4 GPUs)
      num_decode_engines: 2   #   2 decode Dynamo workers  (2 + 2 GPUs) -> 8 GPUs per replica
    mcore_generation_config:  # shared inference settings
      kv_cache_management_mode: persist   # KV blocks must outlive the request for the handoff
      enable_prefix_caching: true
      expose_http_server: false           # Dynamo frontend is the HTTP surface
    vllm_cfg: null
    colocated:
      enabled: false          # generation gets its OWN GPUs, separate from the trainer
      resources:
        num_nodes: 2          #   2 nodes x 8 = 16 inference GPUs
        gpus_per_node: 8      #   16 / 8 per replica = 2 replicas
```

- Prefill width 4, decode width 2, replica width 1·4 + 2·2 = 8.
- 16 / 8 = **2 replicas**. Launch order `[P, D, D, P, D, D]`, prefill first.
- The trainer gets the remaining 24 − 16 = 8 GPUs.

## The example laid out

```
Job (24 GPUs)
│
├── Node 0 ── TRAINER                       ← 8 Megatron *training* workers (TP=2 → 4 copies)
│     ├── training worker (GPU 0)           ← refit rank 0: broadcasts new weights
│     ├── training worker (GPU 1)
│     └── ... (GPU 2–7)                     ← refit ranks 1–7
│
├── CPU services (no GPU)
│     ├── Dynamo frontend                   ← takes HTTP requests, routes to Dynamo workers
│     └── etcd + NATS                       ← registry Dynamo workers sign up in
│
├── Node 1 ── REPLICA 0                     ← 1 prefill + 2 decode Dynamo workers = 8 GPUs
│     │
│     ├── Dynamo worker "prefill-0"         ← one complete model copy, TP=4, width 4
│     │     ├── sidecar                     ← 1 CPU Ray actor
│     │     │     └── adapter process       ← Megatron-LM code; registers as "prefill"
│     │     ├── Megatron worker (GPU 0)     ← refit rank 8
│     │     │     ├── Megatron engine       ← holds 1/4 of every layer + its KV cache
│     │     │     └── coordinator           ← only on GPU 0; adapter sends requests here
│     │     ├── Megatron worker (GPU 1)     ← refit rank 9
│     │     │     └── Megatron engine
│     │     ├── Megatron worker (GPU 2)     ← refit rank 10
│     │     │     └── Megatron engine
│     │     └── Megatron worker (GPU 3)     ← refit rank 11
│     │           └── Megatron engine
│     │
│     ├── Dynamo worker "decode-0"          ← TP=2, width 2
│     │     ├── sidecar
│     │     │     └── adapter process       ← registers as "backend"
│     │     ├── Megatron worker (GPU 4)     ← refit rank 12
│     │     │     ├── Megatron engine       ← holds 1/2 of every layer
│     │     │     └── coordinator
│     │     └── Megatron worker (GPU 5)     ← refit rank 13
│     │           └── Megatron engine
│     │
│     └── Dynamo worker "decode-1"          ← TP=2, width 2
│           ├── sidecar
│           │     └── adapter process
│           ├── Megatron worker (GPU 6)     ← refit rank 14
│           │     ├── Megatron engine
│           │     └── coordinator
│           └── Megatron worker (GPU 7)     ← refit rank 15
│                 └── Megatron engine
│
└── Node 2 ── REPLICA 1                     ← same shape
      ├── Dynamo worker "prefill-1"  (GPU 0–3)   ← refit ranks 16–19
      ├── Dynamo worker "decode-2"   (GPU 4–5)   ← refit ranks 20–21
      └── Dynamo worker "decode-3"   (GPU 6–7)   ← refit ranks 22–23
```

- **Totals:** 6 Dynamo workers (2 prefill + 4 decode), 16 Megatron workers (so 16 Megatron engines), 6 coordinators, 6 sidecars (each with 1 adapter process).
- **Refit group:** 24 ranks, 8 trainer + 16 inference.
- **A replica is not a routing boundary.** The frontend can pair any prefill Dynamo worker with any decode Dynamo worker, e.g. prefill-0 → decode-3 on the other node.

## One request's path

```
Dynamo frontend ──► prefill adapter ──► prefill coordinator ──► 4 engines build KV cache
                                                                    │ KV handoff over NIXL
                                                                    │ (re-cut 4 slices → 2)
                                                                    ▼
                    any decode adapter ◄── decode coordinator ◄── 2 engines generate tokens
```

## How a Dynamo worker starts

Megatron-LM's adapter can run **standalone** (it starts the GPU processes itself with `torchrun`) or **external** (someone else starts them). NeMo-RL uses **external** mode. It must own the Megatron workers to push new weights after every training step, because the adapter has no way to receive new weights.

Per Dynamo worker, in `MegatronDynamoWorkerPool.start`:
1. **Reserve GPUs:** a `RayVirtualCluster` of `width` GPUs on one node.
2. **Start the Megatron workers:** `MegatronGeneration(..., skip_weight_load=True)`. No weights and no Megatron engine yet.
3. **Start the sidecar** (0 GPUs, same node). It `Popen`s the adapter with `--engine-launch-mode external --role prefill|decode`. The adapter opens a socket and waits.
4. **Connect them:** `attach_dynamo_adapter(parent_event_address=…)` tells the Megatron workers the socket address.

Then, at the **first refit**:

5. Weights arrive. Each Megatron worker builds its Megatron engine (`DynamoDynamicInferenceEngine`) and opens its KV transfer channel. GPU 0 starts the coordinator and sends "ready, coordinator at host:port" to the adapter.
6. The adapter registers in etcd/NATS as `prefill`, or `backend` for decode. **This is when the Dynamo worker comes into existence.**
7. `ManagedDynamoRuntime.wait_until_ready` waits until the frontend sees every expected registration, then rollouts start.

## Refit rank layout

The trainer's ranks come first. Each Dynamo worker's Megatron workers start where the previous one's end:

```
Dynamo worker:   0(P)   1(D)   2(D)   3(P)    4(D)    5(D)
width:           4      2      2      4       2       2
prefix:          0      4      6      8       12      14      (cumulative sum of widths)
NCCL ranks:      8-11   12-13  14-15  16-19   20-21   22-23   (= trainer size 8 + prefix)
world_size = 8 + 16 = 24
```

- **The old formula breaks with mixed widths.** `prefix = i * width` would put Dynamo worker 2 at 4, not 6. The fix: `RefitMembership.workers_per_shard` is a tuple of widths, and `worker_offset(i) = sum(widths[:i])`.
- **If one dies (e.g. decode worker 1):** survivors are packed together (prefixes 0, 4, 6, 10, 12; world_size 22). The Ray worker list doesn't shrink, so `worker_offset(3)` is still 4+2+2 = 8.
- **Pause order before a refit:**
  1. Prefill pauses first, so no new handoff starts.
  2. Wait until every prefill Dynamo worker reports zero pinned handoff blocks (decode keeps running and pulls the last ones).
  3. Suspend everything.
  4. Resume decode first, then prefill.

## TL;DR
- Megatron worker = process on 1 GPU. Megatron engine = inference object inside it.
- Dynamo worker = one model copy (TP×PP Megatron workers + sidecar + adapter), registered with the frontend.
- Replica = config-level bundle of P + D Dynamo workers. Width = TP×PP GPUs per Dynamo worker.
- In config, "engine" almost always means Dynamo worker.

## Related
- `Work/LLM/nemo-rl-architecture.md` — the Ray driver/actor layering these workers live in
- `Work/Megatron/disaggregated-inference.md` — Megatron-LM's prefill/decode KV handoff underneath
- `Machine_Learning/LLMs/Inference/prefill-decode.md` — what prefill and decode are
- `Work/LLM/async-grpo-refit-drain.md` — the pause-before-refit problem in general
