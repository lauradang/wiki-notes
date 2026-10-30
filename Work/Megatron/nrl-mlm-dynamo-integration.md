# NRL-MLM Dynamo Integration

The **NRL-MLM Dynamo integration** is how NeMo RL (NRL) serves its own Megatron-LM (MLM) inference engines behind the Dynamo frontend: NRL owns the GPU processes and the weights, and MLM's Dynamo **adapter** attaches to them from outside (`--engine-launch-mode external`).

## The question

MLM's adapter can launch the engine itself (**local mode**). Why does NRL start the engines and attach the adapter from outside instead?

## My misunderstandings, and what's actually true

| I thought | Actually |
|---|---|
| The refit NCCL group is rebuilt every refit | Built **once at setup** (`weight_synchronizer.init_communicator()`), right after the engines exist and before any weights. Every refit after that is just a broadcast on the same group. It's only rebuilt after a failure (`reconcile_communicator` drops dead engines). Regular NRL (vLLM, `backend: megatron`) works the same way |
| `MegatronRefitChannel` merges existing groups into one | It just tells each engine's ranks which rank numbers to take in the one shared group: `rank_offset = trainer ranks + widths of earlier engines` |
| The engine join could live in `pool.start` | The trainer must join at the same time as the engines, and the rendezvous waits for all `world_size` ranks. So the join lives in the synchronizer, called once both sides exist |
| The adapter could just put the engines into the refit group | The adapter is a separate CPU process, not a member. And joining is the easy part: being in the group doesn't mean the engine ever receives |

## How NRL starts the engines (two stages)

```
startup:      per worker → one-node GPU cluster → MegatronGeneration(skip_weight_load=True)
              (Ray actor per GPU + model skeleton, no engine yet) → sidecar launches adapter in external mode
setup:        init_communicator → trainer + every engine rank join one NCCL group
first refit:  weights broadcast → prepare_for_generation builds DynamoDynamicInferenceEngine
              → coordinator up → rank 0 sends "ready" → adapter registers in etcd
```

- The engine is built only after the first weights arrive, because CUDA graphs must be captured on the real weight buffers.

## What the adapter does

Two layers:
- **MLM `MegatronLLMEngine`** (`python -m megatron.inference.integrations.dynamo`) — Dynamo's front door for one worker:
  - registers the worker in etcd once the engine says "ready"
  - translates requests: prefill → "compute and hold the KV"; decode → claim the KV, read it over NIXL, generate, release
  - tracks handoff ownership (claim / release / recovery)
  - forwards KV-cache events to the router; answers health probes
- **NRL `DynamoMegatronAdapterActor`** — CPU-only Ray actor that launches the adapter process next to the engine, assigns its handoff-owner id, and cleans up at shutdown.
- It never touches GPUs or weights.

## Why not let the adapter launch the engine — my summary

- **Not in the group.** Local mode launches the engine with `torchrun --standalone`, so its ranks form their own private world. They are not automatically in the same NCCL group as the trainer.
- **Can't receive even if they were.** An NCCL broadcast only works if every receiver runs its own "receive" code at the same moment the trainer sends. `engine_service` only ever listens to the coordinator (requests, pause/resume); nothing in its loop receives weights from the trainer's group. The trainer would wait forever. NRL solves this because each engine rank is a Ray actor the driver can call: `worker.update_weights_from_collective.remote()`.
- **The receive code is more than receiving.** It also unpacks the packed buffers into each layer's TP/PP slice using a format agreed at setup, pauses/suspends the engine around the swap, and rebuilds the KV cache afterwards. Other per-rank calls exist too: rejoin after a failure, and "how many KV blocks are still pinned" during the refit pause. All of that lives in NRL, so we'd have to reimplement it inside `engine_service`.

## How vLLM gets away with it

Dynamo launches vLLM engines itself, and NRL still refits them, because vLLM has the two hooks MLM lacks:

| Needed | vLLM | MLM adapter |
|---|---|---|
| NRL code inside each engine rank | worker extension | none: fixed engine loop |
| A way to call that code on demand | Dynamo `/engine/*` routes → `collective_rpc` | none: coordinator only speaks requests and pause/resume |

If MLM adds both, local mode becomes possible.

## TL;DR

Joining the NCCL group is one call at startup. Receiving weights needs NRL code inside every engine process, run on demand at every refit. Local-mode MLM engines give NRL no way to put that code there or trigger it, so NRL owns the engine processes and the adapter attaches externally.

## Related
- `Work/LLM/megatron-pd-behind-dynamo.md` — the P/D stack's terms and components
- `Work/Megatron/disaggregated-inference.md` — MLM prefill/decode and KV handoff
- `Work/LLM/async-grpo-refit-drain.md` — the refit pause/resume around the broadcast
- `DevOps/Ray/ray-basics.md` — Ray actors, the control route NRL uses
