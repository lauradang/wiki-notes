# NeMo-RL Architecture

**NeMo-RL** is NVIDIA's RLHF training framework, built on Ray + PyTorch (FSDP2 / Megatron-Core). It supports GRPO, DPO, SFT for LLMs and VLMs, and runs on Kubernetes via KubeRay.

## The layered stack

```
User              nrl-k8s run …
                       │
KubeRay (K8s)     creates pods, runs `ray start`             ▣ infra
                       │
Ray daemons       GCS / Raylet / Plasma                      ▣ infra
                       │
Driver            python run_grpo_*.py                       ▤ code
                  ray.init(address="auto") — attaches
                       │
Actors            Class.remote(...) per role                 ▤ code
  • policy        MegatronPolicyWorker (one per rank)
  • generation    VllmAsyncGenerationWorker
  • environment   NemoGym
                       │
Inside actors     subprocesses / threads spawned at __init__ ▤ code
  • NemoGym       Gym Head/Agent/Model/Resource via subprocess.Popen
  • vLLM          uvicorn thread for HTTP server
                       │
Per rollout       Apptainer SIFs (transient)                 ▤ code
```

▣ = exists before training script runs · ▤ = created at runtime by NeMo-RL code

## The three actor types

| Actor | Decorator | What it owns | How many |
|---|---|---|---|
| `MegatronPolicyWorker` | `@ray.remote` | One torch.distributed rank, one slice of model weights + optimizer | One per training GPU |
| `VllmAsyncGenerationWorker` | `@ray.remote(num_gpus=1)` | vLLM `AsyncLLM` engine + uvicorn HTTP server thread | One per generation GPU |
| `NemoGym` | `@ray.remote(max_restarts=-1)` | Bridge to NeMo Gym; spawns Gym servers as OS subprocesses | One total |

Each Megatron actor names itself `MegatronPolicyWorkerImpl[rank=N]` where `N = torch.distributed.get_rank()`. The `RayWorkerGroup` wires them into TP / PP / CP / EP / DP groups via Megatron-Core's `parallel_state`.

## Colocated vs disaggregated

Two ways to share GPUs between training and generation:

| Mode | `colocated.enabled` | Layout |
|---|---|---|
| Colocated | `true` | Generation actors share GPUs with training actors. Weights swap in/out via refit. |
| Disaggregated | `false` | Generation actors get their own GPU bundles. Training and inference run on disjoint GPUs. |

Disaggregated uses `PACK` strategy so each placement-group bundle stays contiguous within a node.

## Refit

After each training step, policy weights are synchronized to the vLLM workers so generation uses up-to-date params:

```
Policy actors ─── NCCL transfer ───► vLLM actors
```

Refit is direct GPU↔GPU via NCCL — no host roundtrip, no Ray RPC for the payload.

## NeMo Gym integration

NeMo Gym is a separate NVIDIA project providing HTTP-based RL environments (math, tool use, agentic coding). It's CPU-only — no GPUs, no inference engine. NeMo-RL exposes its vLLM workers via HTTP, and NeMo Gym calls them.

```
NemoGym actor (Ray actor on head pod, CPU)
   │ spawns OS subprocesses at __init__
   ▼
Gym Head Server · Agent Server · Model Server · Resource Server
                                     │
                                     │ HTTP POST /v1/chat/completions
                                     ▼
                          vLLM workers' uvicorn endpoints
                          (base_url = NODE_IP:FREE_PORT per DP rank)
```

The Gym Model Server is a pure HTTP proxy: translates OpenAI Responses API ↔ Chat Completions and load-balances across vLLM `base_url`s. vLLM never knows it's being called through Gym.

Enable with:
```yaml
policy:
  generation:
    vllm_cfg:
      async_engine: true
      expose_http_server: true
env:
  should_use_nemo_gym: true
  nemo_gym:
    config_paths: [responses_api_agents/.../config.yaml]
```

## Rollout flow (one batch)

```
Driver
  │ refit.remote()
  ▼
Policy actors ── NCCL ──► vLLM workers   (weights synced)
  │
  │ gym_actor.run_rollouts.remote(batch)    ← Ray RPC
  ▼
NemoGym actor
  │ POST /run
  ▼
Gym Agent Server
  │ POST /v1/responses
  ▼
Gym Model Server ─ HTTP /v1/chat/completions ─► vLLM uvicorn
                                                   │
                                                   ▼
                                          AsyncLLM forward on GPU
  │ ...chat completion response back up...
  ▼
Agent Server
  │ (for swe_agents) spawns Apptainer SIFs:
  │    • OpenHands agent container
  │    • SWE-bench eval harness container
  ▼
results + reward
  │ back up: Gym → NemoGym actor → driver
  ▼
GRPO loss → backward → optimizer step on policy actors
```

## SWE-agent rollouts

The `responses_api_agents/swe_agents` module in the Gym repo lets the trainer hand off a SWE-bench row and get back `(trajectory, reward, mask)` for GRPO. Per row, on a Ray worker:

1. Spawn two Apptainer (Singularity) containers in parallel:
   - **Agent container** — OpenHands inside the row's task SIF; edits files, writes unified diff
   - **Eval container** — busy-waits for the patch file, then runs the dataset's local eval harness
2. Containers share `/trajectories_mount` (bind mount).
3. Reward = `1.0 if resolved else 0.0`.
4. Trajectory converted to Responses-API items, returned through the Gym → NeMo-RL pipeline.

SIFs are per-instance images like `xingyaoww_sweb.eval.x86_64.{instance_id}.sif`. Not Ray actors, not K8s pods — just `apptainer exec` subprocesses inside an existing Ray worker.

## Async GRPO

In `nemo_rl/algorithms/async_utils/trajectory_collector.py`, when `should_use_nemo_gym` is set, the collector calls `run_async_nemo_gym_rollout(...)` in place of `run_async_multi_turn_rollout(...)`. The async lag / in-flight machinery (e.g. `max_trajectory_age_steps`, `lag_mode: unforced`) layers around the Gym call — NeMo Gym doesn't know it's being driven asynchronously.

## Communication protocols in NeMo-RL

| Between | Protocol |
|---|---|
| Driver ↔ actors, actor ↔ actor | Ray RPC (gRPC) |
| Policy ↔ vLLM weights | NCCL (during refit), pod-to-pod |
| TP / PP / CP / EP / DP groups | NCCL within a Megatron group |
| NeMo Gym ↔ vLLM | HTTP (Gym Model Server → vLLM uvicorn) |
| Agent Server ↔ Apptainer SIFs | OS subprocess + bind mounts |

## Related
- `DevOps/Ray/ray-basics.md` — Ray concepts NeMo-RL is built on (actors, placement groups, etc.)
- `Machine_Learning/LLMs/grpo.md` — the RL algorithm NeMo-RL implements
- `DevOps/Kubernetes/kubernetes-architecture.md` — KubeRay runs on K8s
