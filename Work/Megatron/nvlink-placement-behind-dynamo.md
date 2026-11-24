# NVLink Placement Behind Dynamo

**`nvlink_domain_span`** is the startup hint that says "never split a group of this many GPUs across NVLink domains". For Megatron prefill/decode engines behind Dynamo it should be the **widest engine**, not the whole prefill+decode replica.

> Context: jthomson04's review comment on NVIDIA-NeMo/RL#4801 (`MegatronGeneration.nvlink_domain_span`), fixed in 65b2e6bac.

## What runs where

```
                      ┌────────────────────────────────┐
  Gym / rollouts ───► │ Dynamo FRONTEND (one per fleet) │  HTTP + router
                      │ router sees ALL engines         │
                      └───────┬───────────────┬────────┘
                   (1) pick   │               │ (2) pick
                   a prefill  │               │ a decode
                   engine     ▼               ▼
   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
   │ P0          │  │ P1          │  │ D0          │  │ D1 ...      │
   │ adapter@r0  │  │ adapter@r0  │  │ adapter@r0  │  │ adapter@r0  │
   │ TP ranks    │  │ TP ranks    │  │ TP ranks    │  │ TP ranks    │
   └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘
          └──────(3) KV cache sent once, P → D ───────────►┘
```

- **Frontend** — HTTP server + router. One for the whole fleet (or `num_frontends`, but each still routes across the whole fleet).
- **Adapter** — Megatron-LM's Dynamo adapter on each engine's rank 0. It registers the engine with the frontend and takes requests; it does **not** route.
- "A frontend per engine" was the old per-engine Gym proxy (removed from PR 6) or plain non-Dynamo Megatron (its own HTTP server per engine).

## What "placement" is

The startup step that decides which physical GPU each worker process runs on. Fixed for the whole run.

1. **Pick nodes** (`single_controller_utils/setup.py` `_build_clusters`) — which machines become inference nodes; with topology-aware placement, chunks from one NVLink domain.
2. **Reserve GPU slots** (`virtual_cluster.py` `_init_placement_groups`) — Ray placement groups, either one per node or one unified across nodes.
3. **Start workers into the slots in order** — engine 0 takes the first N slots, engine 1 the next, …

```
node A: [g0 g1 g2 g3 | g4 g5 g6 g7]
         └ engine P0 ┘ └ engine D0 ┘
node B: [g0 g1 g2 g3 | g4 g5 g6 g7]
         └ engine D1 ┘ └ engine P1 ┘
```

## What the number is used for

| Use | Code | Rule |
|---|---|---|
| Node chunks (only when `segment_size` is set) | `setup.py` | `nodes_per_instance = ceil(span / gpus_per_node)`; nodes are picked in chunks of that many, each from one NVLink domain. If inference nodes don't divide evenly → warn and **skip** topology placement |
| Placement-group shape | `megatron_generation.py` `init_cluster_placement_groups` | `use_unified_pg = span > gpus_per_node` → one placement group spanning all nodes, else one per node |

## Why the router decides it — step by step

1. Prefill hands its KV cache to decode **once per request**. Fast if both are on one NVLink domain, slower across the network.
2. The old code said: put each replica (P0 + D0 + D1) on one NVLink domain so P0 → D0 is fast.
3. That only pays off if P0's requests actually go to D0/D1 — the handoff must **stay inside the replica**.
4. Who picks the decode engine? **The router.** So the router decides whether step 3 holds.

**TRT-LLM** — each replica has its own frontend that sees only its own engines:

```
replica 0 frontend → P0 → D0 or D1      (always inside replica 0)
replica 1 frontend → P1 → D2 or D3      (always inside replica 1)
```

Handoff stays inside → grouping the replica on NVLink is worth it.

**Dynamo** — one router sees every engine and picks any decode engine:

```
router → P0 → D3     (P0 in replica 0, D3 in replica 1)
router → P1 → D0     (P1 in replica 1, D0 in replica 0)
```

Handoff leaves the replica → grouping the replica buys nothing, only costs placement freedom.

Analogy: seating each team at one table only helps if people mostly talk to their own team.

## What does need NVLink — and why it's not the router's call

| Traffic | Who decides which GPUs talk | Known at placement time? |
|---|---|---|
| Prefill → decode KV handoff | the router, per request | no — any decode engine |
| Inside one engine (TP) | fixed when the engine is built | yes — always the same GPUs |

- TP 4 = 4 GPUs each hold a quarter of every layer; on every layer of every token they all-reduce partial results — thousands of exchanges per request, always among the same GPUs.
- So the only group placement can usefully keep together is **one engine**.

## Worked example

8-GPU nodes, 3 inference nodes, 1 prefill + 2 decode engines, all TP 4.

| | Old: span = replica (4+4+4 = 12) | New: span = widest engine (4) |
|---|---|---|
| Node chunks | 2-node chunks; 3 % 2 ≠ 0 → topology placement **skipped** | 1-node chunks, works |
| Placement groups | unified cross-node, though every engine fits on one node | one per node |

## The fix

```python
# megatron_generation.py — nvlink_domain_span
# before
if dynamo_enabled(config["generation"]):
    return replica_width(config)                 # e.g. 4+4+4 = 12
# after
if dynamo_enabled(config["generation"]):
    return max(engine_widths(config).values())   # e.g. 4
```

- `replica_width` still exists — it only fixes the P:D ratio when laying out the fleet; it is not an NVLink unit.
- `replica_width_from`'s "replica stays in one NVLink domain" rule is TRT-LLM-only (TRT-LLM still uses it).
- Wrinkle: `engine_width` is TP × PP. Plain Megatron leaves PP out of its span (pipeline traffic is light), so a stricter rule would use TP and the expert grid only.

## TL;DR

The NVLink span answers "which GPUs talk constantly and predictably?" Behind Dynamo the router scatters KV handoffs across the fleet, so the replica isn't that group — one engine's TP ranks are.

## Related
- `Work/Megatron/disaggregated-inference.md` — prefill/decode engines and the KV handoff
- `Work/Megatron/nrl-mlm-dynamo-integration.md` — how NeMo-RL hosts Megatron-LM's Dynamo adapter
- `Work/LLM/megatron-pd-behind-dynamo.md` — the P/D stack this fix lives in
- `DevOps/Ray/ray-basics.md` — Ray placement groups
