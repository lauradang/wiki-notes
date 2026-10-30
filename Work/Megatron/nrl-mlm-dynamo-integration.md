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
| NRL doesn't use MLM's adapter | It does, in **external** mode: the adapter still registers the worker and handles requests. NRL just starts the GPU ranks itself instead of letting the adapter `torchrun` them |
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

## We DO use the adapter — just not in local mode

The adapter (`MegatronLLMEngine`) runs in both modes. The only thing that changes is **who starts the GPU ranks under it**. NRL's `DynamoMegatronAdapterActor` passes `--engine-launch-mode external`, and that flips one `if` inside the adapter's `start()`.

### The fork inside the adapter

`megatron/inference/integrations/dynamo/llm_engine.py:186-213` (`MegatronLLMEngine.start`):

```python
            self._event_receiver = EngineEventReceiver(
                self._on_engine_event,
                self.config.parent_event_host,
                bind_port=self.config.parent_event_port,
            )
            parent_event_address = self._event_receiver.start()
            if self.config.engine_launch_mode == "local":
                command = self._engine_command(parent_event_address)
                logger.info("Launching owned Megatron engine: %s", " ".join(command))
                self._process = await asyncio.create_subprocess_exec(
                    *command,
                    cwd=self.config.megatron_root,
                    stdout=asyncio.subprocess.PIPE,
                    stderr=asyncio.subprocess.PIPE,
                    start_new_session=True,
                )
                assert self._process.stdout is not None
                assert self._process.stderr is not None
                self._log_tasks = [
                    asyncio.create_task(self._forward_logs(self._process.stdout, logging.INFO)),
                    asyncio.create_task(self._forward_logs(self._process.stderr, logging.WARNING)),
                ]
            else:
                logger.info(
                    "Waiting for an externally launched Megatron engine at %s", parent_event_address
                )
            return await self._complete_startup()
```

- **Both modes:** open the event socket, the address engine rank 0 later sends "ready" / "progress" / KV events to.
- **Local:** launch the engine as the adapter's own child process (the `torchrun --standalone` command below).
- **External (NRL):** start nothing, just log and wait. NRL's own workers connect to the socket.
- **Both modes:** `_complete_startup()` waits for "ready", connects `InferenceClient` to the coordinator, and returns the config that registers the worker in etcd.

```
start()
 ├─ open event socket                      (both)
 ├─ local?    → torchrun --standalone engine_service    ← adapter owns the ranks
 │  external? → just wait                               ← NRL owns the ranks
 └─ _complete_startup: wait "ready" → connect coordinator → register   (both)
```

### What local mode launches

`_engine_command` (`llm_engine.py:280-290`) — a private `torchrun` world:

```python
        command = [
            sys.executable,
            "-m",
            "torch.distributed.run",
            "--standalone",
            f"--nproc-per-node={self.config.nproc_per_node}",
            "--module",
            "megatron.inference.integrations.dynamo.engine_service",
            "--dynamo-parent-event-address",
            parent_event_address,
            "--role",
```

Each rank then runs `engine_service._serve` (`engine_service.py:57-75`), which ends in a loop that only serves:

```python
    if disaggregated:
        engine.setup_kv_transfer(role=args.role, require_handoff_claim=True)

    reporter = EngineEventReporter(engine, args.dynamo_parent_event_address)
    if disaggregated:
        engine.set_progress_callback(lambda: reporter.observe("progress", {}))
    reporter.start()

    try:
        address = await engine.start_listening_to_data_parallel_coordinator(
            inference_coordinator_port=args.coordinator_port, hostname=args.coordinator_host
        )
        if dist.get_rank() == 0:
            endpoint = InferenceEngineEndpoint.from_engine(
                address, engine, logical_data_parallel_size=replica_count
            )
            reporter.observe("ready", endpoint.to_dict())
        await engine.engine_loop_task
```

`await engine.engine_loop_task` is where the process stays forever: requests and pause/resume only, no way to receive weights.

### What NRL runs instead (external mode)

NRL's `MegatronPolicyWorker` does the same reporter + "ready" steps as `engine_service`, but inside a Ray actor that also has refit methods. `nemo_rl/models/generation/megatron/megatron_worker.py:422-455`:

```python
    def _start_dynamo_event_reporter(self) -> None:
        """Connect the engine's events to the adapter before the coordinator starts."""
        assert self._dynamo_adapter is not None
        # Deferred: the Dynamo integration is optional (absent from older
        # Megatron-LM) and only Dynamo-attached engines load it.
        from megatron.inference.integrations.dynamo.telemetry import (
            EngineEventReporter,
        )

        reporter = EngineEventReporter(
            self.dynamic_inference_engine,
            self._dynamo_adapter.parent_event_address,
        )
```

```python
    def _report_dynamo_ready(self) -> None:
        """Rank zero tells the adapter where the coordinator is and what it serves."""
        reporter = self._dynamo_event_reporter
        if reporter is None or torch.distributed.get_rank() != 0:
            return
        # Deferred: only Dynamo-attached engines use it, and it ships only with
        # the Megatron-LM versions that carry the Dynamo integration.
        from megatron.core.inference.engine_endpoint import InferenceEngineEndpoint

        endpoint = InferenceEngineEndpoint.from_engine(
            self.coordinator_addr,
            self.dynamic_inference_engine,
            logical_data_parallel_size=1,
        )
        reporter.observe("ready", endpoint.to_dict())
```

### Engine vs the process around it

```
LOCAL MODE                                   EXTERNAL MODE (NRL)

GPU process = engine_service (MLM)           GPU process = MegatronPolicyWorker (NRL Ray actor)
┌─────────────────────────────────┐          ┌─────────────────────────────────────────┐
│ main loop:                      │          │ methods the driver can call:            │
│   await engine_loop_task        │          │   init_collective()          join group │
│   (requests, pause/resume only) │          │   update_weights_from_collective()      │
│                                 │          │   pause_for_refit() / resume ...        │
│  ┌───────────────────────────┐  │          │  ┌───────────────────────────────────┐  │
│  │ DynamoDynamicInference-   │  │          │  │ DynamoDynamicInferenceEngine      │  │
│  │ Engine  (same class)      │  │          │  │ (same class)                      │  │
│  │ weights ← checkpoint      │  │          │  │ weights ← written by refit methods│  │
│  └───────────────────────────┘  │          │  └───────────────────────────────────┘  │
└─────────────────────────────────┘          └─────────────────────────────────────────┘
```

- The **engine object** is identical and never receives weights itself, in either mode.
- The **wrapper process** decides whether weights can arrive. `engine_service` can't be asked to; NRL's worker can, because the driver calls `update_weights_from_collective` on it, which writes the new values into the tensors the engine reads.

### Who launches what

| | Local mode (MLM) | External mode (NRL) |
|---|---|---|
| Starts the adapter | Deployment script / user | `DynamoMegatronAdapterActor` |
| Starts the GPU ranks | The adapter, via `torchrun --standalone` | NRL: `MegatronGeneration` Ray actors |
| Weights come from | Checkpoint (`--load`), once | Trainer over the refit NCCL group, every step |
| Sends "ready" | `engine_service` rank 0 | NRL worker rank 0 (`_report_dynamo_ready`) |
| After "ready" | Same in both: adapter connects to the coordinator, registers in etcd, serves requests | Same |

## Why not let the adapter launch the engine (local mode) — my summary

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
