# Async GRPO Refit Drain

Why in async GRPO you sometimes have to halt rollouts before swapping in fresh weights, and why "sometimes" depends on the rollout path.

## What refit actually is

Refit copies fresh weights from the trainer GPUs to the vLLM (generation) GPUs. The mechanism: a single NCCL broadcast over a process group that spans both pools — trainer rank 0 produces, every vLLM worker consumes.

NCCL collectives are synchronous. Every member of the group must enter the same call before any of them can return. No timeout, no out-of-band signaling. If even one vLLM worker is missing, trainer rank 0 blocks indefinitely.

On the vLLM side, "entering the broadcast" is not a direct function call — it's a `collective_rpc` scheduled into the vLLM async engine's event loop, run between forward batches. It only gets to run when the engine's work queue has room for it.

## The three paths

| Path | Wait for in-flight to finish? | Source of vLLM requests |
|---|---|---|
| Direct + in-flight weight updates | no | driver only |
| Direct + no in-flight updates | yes | driver only |
| NeMo-Gym | yes (real drain) | rollout threads, not driver |

## Direct + in-flight: no drain

vLLM V1 async engine can interleave a weight swap with active forward passes. Existing `generate_async` calls don't need to *finish* — they keep going through refit and complete their remaining tokens on the new weights.

What's required is just that no *new* requests arrive. The driver is the only producer of `generate_async` calls, so closing the driver's spigot (pausing new starts) is enough. The in-flight set is bounded, the engine queue eventually has room for the collective RPC, the rendezvous succeeds.

## Direct + no in-flight: trivial drain

Without in-flight update support, the engine can't interleave the swap. So in-flight requests must fully finish before refit. Drain is straightforward — wait for the bounded set of `generate_async` calls to return, then run the collective.

## NeMo-Gym: real drain needed

The catch: in NeMo-Gym, the driver is *not* the producer of vLLM requests. Each rollout is a multi-turn loop run by a rollout thread inside the trajectory collector:

1. POST `/v1/chat/completions` to vLLM  (turn 1)
2. Get response, run environment / tool code locally
3. POST again  (turn 2)
4. … repeats until done

vLLM has no idea these are part of the same rollout. Each HTTP request looks independent.

When refit is signaled, the driver pauses *new rollouts from being started*. But existing rollout threads keep advancing through their multi-turn loops and firing follow-up HTTP requests at unpredictable times. New work keeps arriving at vLLM. The engine never has stable room for the collective. The trainer-side broadcast — already initiated, waiting for vLLM to join — blocks forever.

The fix is an explicit drain: wait for every rollout thread to be past its **last** HTTP call into vLLM before letting refit proceed. Once that's true, vLLM's queue genuinely empties, the collective runs, refit completes.

## The "backend-active" refinement

A rollout thread's lifecycle is roughly:

1. talk to vLLM (the "backend-active" phase)
2. run local post-processing (tokenize, push to replay buffer)
3. exit

Only phase 1 can deadlock refit — once a thread is past its last HTTP call, vLLM is free regardless of what the thread does next. So the drain waits only on threads still in phase 1, not on all threads. That trims the exposed-generation time the trainer waits.

## TL;DR

Whether a drain is needed comes down to **who owns the input pipe into vLLM**.

- Driver owns it (direct path) → pausing at the driver closes the pipe → no drain needed; in-flight updates handle the rest.
- Something outside the driver owns it (NeMo-Gym rollout threads) → the only way to close the pipe is to wait for those external owners to finish talking to vLLM.

## Related
- `Work/LLM/nemo-rl-architecture.md` — overall actor topology this synchronization sits inside
- `Machine_Learning/LLMs/grpo.md` — the algorithm being run
- `DevOps/Ray/ray-basics.md` — Ray actor concepts underlying the trajectory collector
