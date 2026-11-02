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

## Object map: one Dynamo worker

Engine = `DynamicInferenceEngine` (here the subclass `DynamoDynamicInferenceEngine`). There is **one engine per GPU rank**, and all engines of one Dynamo worker share **one coordinator**. "Dynamo worker" is a concept (one routable copy of the model), not a class; NRL's record of it is `DynamoWorkerRecord`.

- **Coordinator** — one CPU process per Dynamo worker; the single entry point into its engines. Spawned by the rank with TP=0, PP=0, DP=0 (= rank 0 here, since each worker has DP=1) inside `start_listening_to_data_parallel_coordinator` (`dynamic_engine.py:1358-1373`). Listens on the node IP so the adapter and the other role's adapters can reach it.
- **`InferenceClient`** — MLM's ZMQ client to a coordinator. Only **callers** have one; the engines do not. Two per worker:
  - ① the **adapter's** — sends requests in, gets results back
  - ② **NRL rank 0's** — sends pause / suspend / resume / unpause around a refit
- **Engines** — connect to the coordinator through their own sockets, not through an `InferenceClient`. The coordinator talks only to **rank 0's engine**; rank 0's engine **republishes** each message to the other TP/PP ranks over a ZMQ publish/subscribe socket.

Rank 0's process holds both an engine and client ②, but they are two separate objects: the engine listens on its socket, client ② is NRL's control phone.

```
ONE DYNAMO WORKER  (e.g. prefill-0)        = what the frontend routes to; NRL keeps a DynamoWorkerRecord for it
│
├── DynamoMegatronAdapterActor   (NRL, CPU Ray actor)            × 1
│     └── adapter process = MegatronLLMEngine (MLM)              × 1
│           └── InferenceClient ①  ── requests ──────────────┐
│                                                            ▼
│                                                  ┌──────────────────────┐
│                                                  │ Coordinator          │
│                                                  │ (CPU process, × 1)   │
│                                                  └──────────────────────┘
│                                                     ▲            │ sends only to rank 0's engine
└── MegatronGeneration  (NRL)  × 1                    │            │
      │  one torch.distributed world of TP×PP ranks   │            │
      │                                               │            ▼
      ├── MegatronPolicyWorker rank 0 (GPU 0, Ray actor)
      │     ├── InferenceClient ② ── pause/suspend/resume ──┘
      │     ├── spawned the coordinator
      │     └── DynamicInferenceEngine  ◀── coordinator messages
      │            │ ZMQ PUB (republish to the rest of the TP/PP group)
      │            ▼
      ├── MegatronPolicyWorker rank 1   └── DynamicInferenceEngine  (ZMQ SUB)
      ├── …
      └── MegatronPolicyWorker rank N-1 └── DynamicInferenceEngine  (ZMQ SUB)
```

| Thing | Count per worker (N = TP×PP) | Created by | Code |
|---|---|---|---|
| `DynamoWorkerRecord` | 1 | `MegatronDynamoWorkerPool.start` | `megatron_worker_pool.py:860` |
| `MegatronGeneration` | 1 | same | `megatron_worker_pool.py:837` |
| `MegatronPolicyWorker` (Ray actor, 1 GPU) | N | `MegatronGeneration` → `Policy` worker group | `megatron_generation.py:375` |
| `DynamicInferenceEngine` | N | each rank, at the first refit | `megatron_worker.py:842` |
| Coordinator | 1 | rank 0, spawned CPU process | `dynamic_engine.py:1358-1373` |
| `InferenceClient` ① requests | 1 | adapter, after "ready" | `llm_engine.py:228` |
| `InferenceClient` ② refit control | 1 | NRL rank 0 | `megatron_worker.py:877` |
| Adapter sidecar + adapter process | 1 each | `_start_adapter` | `megatron_worker_pool.py:905` |

A replica (`prefill-0` + `decode-0`) is two of these boxes: 2 `MegatronGeneration`s, 2 coordinators, 2 adapters, 2×N engines.

### What each client sends

| | Adapter's client ① | NRL rank 0's client ② |
|---|---|---|
| Purpose | Requests | Refit control |
| Calls | `add_request_streaming` (prefill), `add_request_with_kv_handoff_streaming` (decode), `abort_request_and_wait`, `release_handoff` | `pause_engines`, `suspend_engines`, `resume_engines`, `unpause_engines` |
| Header on the wire | `SUBMIT_REQUEST` / `SUBMIT_REQUEST_WITH_KV` | `PAUSE` / `SUSPEND` / `RESUME` / `UNPAUSE` |
| Coordinator handler | `handle_submit_request`: remembers the sender, routes to an engine | `handle_control_signal`: updates coordinator state, broadcasts |
| Reply? | Yes — `ENGINE_REPLY` streamed back to this client | No — NRL confirms in-process (`wait_until(EngineState.PAUSED)` + barrier) |

Rank 0's client also has `add_request_with_id` / `abort_request` / `set_generation_epoch`, but those are NRL's non-Dynamo paths; in the Dynamo setting every request comes through the frontend and the adapter.

Not through any `InferenceClient`: decode adapters send `CLAIM_KV` / `RELEASE_KV` over their own ZMQ socket straight to the **prefill** coordinator (`_remote_handoff_command`, `llm_engine.py:618`). So a prefill coordinator hears from three senders: its adapter's client ①, its NRL rank 0 client ②, and decode adapters.

The adapter's client *can* send PAUSE (it does in `cleanup()` at shutdown), but it can't run a refit: nothing in NRL can tell it when, it can't confirm every rank reached PAUSED, the weight swap runs inside the ranks, and the prefill→decode pause order spans workers.

### The code, end to end

All MLM paths are under `megatron/core/inference/` (MLM `ed9c2c8`).

**Shared: connect.** Client `inference_client.py:105-111`, `:644-659`:

```python
        socket = self.context.socket(zmq.DEALER)
        ...
        socket.connect(inference_coordinator_address)
```

```python
        payload = [Headers.CONNECT.value]
        self.socket.send(msgpack.packb(payload, use_bin_type=True))
        ...
        reply = msgpack.unpackb(self.socket.recv_multipart()[0], raw=False)
        assert Headers(reply[0]) == Headers.CONNECT_ACK
```

Coordinator `data_parallel_inference_coordinator/handlers.py:95-109` (`handle_connect`):

```python
    coordinator.known_clients.add(sender_identity)
    coordinator._send_to_client(
        [
            sender_identity,
            msgpack.packb([Headers.CONNECT_ACK.value, coordinator.instance_id], use_bin_type=True),
        ]
    )
```

**Shared: coordinator main loop** (`coordinator.py:646-662`) — receive, read the header, dispatch to a handler:

```python
                sender_identity, *frames = self.router_socket.recv_multipart()
            ...
            metadata = msgpack.unpackb(frames[0], raw=False)
            header = Headers(metadata[0])

            handler = self._handlers.get(header)
            ...
            if handler(self, sender_identity, metadata, frames[1:]):
```

**Shared: rank 0's engine relays to the other ranks** (`engines/dynamic_engine.py:4658`, `schedule_requests`): rank 0 (`is_mp_coordinator`) drains `socket_for_receiving_requests` and republishes on `model_parallel_publisher_socket`; the other ranks read `model_parallel_subscriber_socket`. Sockets are set up in `start_listening_to_data_parallel_coordinator` (`:1433-1497`).

**Path ② — NRL rank 0 pauses for refit.** `nemo_rl/models/generation/megatron/megatron_worker.py:919-922`:

```python
    async def _pause_engine(self):
        if torch.distributed.get_rank() == 0:
            self.inference_client.pause_engines()
        await self.dynamic_inference_engine.wait_until(EngineState.PAUSED)
```

→ `inference_client.py:678-688` (`_send_signal_to_engines`):

```python
        payload = [signal.value, *args]
        payload_serialized = msgpack.packb(payload, use_bin_type=True)
        self.socket.send(payload_serialized)
```

→ coordinator `handlers.py:487-524` (`handle_control_signal`):

```python
    if sender_identity not in coordinator.known_clients:
        logging.warning("Coordinator: ignoring signal from unknown client.")
        return
    ...
    if transition.new_state is not None:
        coordinator.state = transition.new_state
    ...
    coordinator._broadcast_to_engines(metadata)
```

→ `_broadcast_to_engines` (`coordinator.py:415-419`) sends to each DP rank's engine (DP=1 → only rank 0's), which relays to the others → each engine (`dynamic_engine.py:4951-4954`):

```python
            if header == Headers.PAUSE:
                if self.state == EngineState.RUNNING:
                    self.state = EngineState.PAUSING
```

No reply goes back to client ②. Every NRL rank confirms on its own: `wait_until(EngineState.PAUSED)` then `torch.distributed.barrier()`.

**Path ① — adapter sends a prefill request.** `megatron/inference/integrations/dynamo/llm_engine.py:376-378`:

```python
            params.do_kv_handoff = True
            params.num_tokens_to_generate = 0
            stream = self.client.add_request_streaming(token_ids, params)
```

→ `inference_client.py:550-560` (`_submit_stream`):

```python
        self.socket.send_multipart(frames)
        stream = AsyncStream(
            request_id, functools.partial(self.abort_request, request_id), loop=self._loop
        )
        self.streams[request_id] = stream
```

→ coordinator `handlers.py:112`, `:195-202` (`handle_submit_request`) — remember who asked, route to an engine:

```python
    coordinator.request_id_to_client_id[request_id] = sender_identity
    ...
    engine_metadata = msgpack.packb(
        [Headers.SUBMIT_REQUEST.value, request_id, sampling_params, media_meta], use_bin_type=True
    )
```

→ engines run it → coordinator `handlers.py:548-607` (`handle_engine_reply`) — send the result back to that client:

```python
        client_identity, client_request_id = coordinator._forget_client_request(fid)
        ...
        reply_metadata = msgpack.packb(
            [Headers.ENGINE_REPLY.value, client_request_id], use_bin_type=True
        )
        coordinator._send_to_client([client_identity, reply_metadata, body])
```

→ client `_recv_task` (`inference_client.py:562`) pushes the chunk into the request's `AsyncStream`, which the adapter reads and forwards to Dynamo.

### One request / one refit pause, in steps

**One request**
1. Frontend routes to `prefill-0` → its adapter
2. Adapter: client ① `add_request_streaming(...)` → `SUBMIT_REQUEST`
3. Coordinator records the sender, sends the request to rank 0's engine
4. Rank 0's engine republishes it to ranks 1…N-1; all N run the forward pass together, each on its TP/PP slice
5. Rank 0's engine sends `ENGINE_REPLY` → coordinator → client ① → adapter → Dynamo

**One refit pause**
1. `MegatronRefitChannel` → Ray call on every `MegatronPolicyWorker`
2. Rank 0: client ② `pause_engines()` → `PAUSE`
3. Coordinator updates its state, sends PAUSE to rank 0's engine, which republishes to the others
4. Every rank waits until its own engine reports PAUSED, then all ranks meet at a barrier

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
