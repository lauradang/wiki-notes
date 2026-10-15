# Context Parallelism

**Context parallelism (CP)** splits a single long sequence's tokens across GPUs, so sequences too long for one GPU's memory can still be trained on.

## Why

Attention activation memory grows with sequence length. A 128k-token sequence may not fit on one GPU — so each of the `CP` GPUs holds only a slice of the tokens.

## How attention still sees the full context

Each GPU computes attention for its own query tokens, while **keys/values are passed around a ring** of GPUs (point-to-point, "P2P") so every query eventually sees every relevant key.

## Load balancing: 2 × CP chunks

With causal attention, later tokens attend to more earlier tokens — more work. Naive contiguous slices would overload the last GPU. Instead each sequence is cut into **2 × CP** chunks; GPU *i* takes chunk *i* and chunk *2·CP − 1 − i*:

```
CP = 2, one sequence → 4 chunks:   [c0 | c1 | c2 | c3]
   GPU 0 gets c0 + c3     (cheap + expensive)
   GPU 1 gets c1 + c2     (medium + medium)
```

So every sequence must divide evenly into `2·CP` chunks → this is why **padded** boundaries (`cu_seqlens_padded`) exist for packed sequences.

## With packed THD sequences

TransformerEngine locates each GPU's chunks *inside* the packed row by computing positions from `cu_seqlens_padded`. Wrong offsets → wrong chunk positions → possible out-of-bounds indexing.

## Where it fits among parallelism types

| Type | Splits |
|---|---|
| **DP** (data) | The batch — each GPU has a full model copy |
| **TP** (tensor) | Each layer's weight matrices |
| **PP** (pipeline) | The model by layers |
| **CP** (context) | One sequence's tokens |

## Related
- `Work/Megatron/packed-thd-sequences.md` — `cu_seqlens_padded` and the packed layout CP chunks over
- `Work/Megatron/cuda-graphs.md` — CP + CUDA graphs + packed THD warmup crash (PR #8124)
- `Work/Megatron/disaggregated-inference.md` — TP/PP/DP groups in Megatron
