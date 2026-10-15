# Packed THD Sequences

**Packing** concatenates variable-length sequences into one long row instead of padding each to the same length; **THD** is the resulting tensor layout — **T**okens × **H**eads × **D**im per head.

## Padding vs packing

```
padded (BSHD):  [a a a _ _ _ _]
                [b b b b b _ _]      ← "_" = wasted compute
                [c c _ _ _ _ _]

packed (THD):   [a a a b b b b b c c]
                 0     3         8   10
```

## cu_seqlens — the only record of the boundaries

```
cu_seqlens = [0, 3, 8, 10]     # cumulative sequence lengths: start/end of each sequence
```

- Attention uses it so tokens of `a` never attend to tokens of `b`.
- `len(cu_seqlens) = num_sequences + 1`.
- **`cu_seqlens_padded`** — the same boundaries after each sequence is rounded up to a convenient multiple (e.g. so it divides evenly into context-parallel chunks). With `pad_between_seqs=True` the physical buffer has gaps:

```
cu_seqlens        = [0, 3, 8]
cu_seqlens_padded = [0, 4, 12]       # a: 3 real + 1 pad,  b: 5 real + 3 pad
```

These are **indices, not data** — their exact values matter, and wrong values can produce out-of-bounds indexing.

## In Megatron

`megatron/core/packed_seq_params.py` → `PackedSeqParams` (a dataclass) carries:

| Field | Meaning |
|---|---|
| `qkv_format` | `"thd"` for packed |
| `cu_seqlens_q` / `cu_seqlens_kv` | Real boundaries |
| `cu_seqlens_q_padded` / `cu_seqlens_kv_padded` | Padded (physical) boundaries |
| `max_seqlen_q` / `max_seqlen_kv` | Longest sequence (kernel sizing) |
| `seq_idx` | Per-token sequence id, precomputed in `__post_init__` for Mamba |

Example `seq_idx` for `cu_seqlens_padded=[0,5,7,11]`, 16 tokens: `[0,0,0,0,0,1,1,2,2,2,2,3,3,3,3,3]` (an extra id covers trailing tokens).

## Related
- `Work/Megatron/context-parallelism.md` — why padded boundaries exist (even CP chunking)
- `Work/Megatron/cuda-graphs.md` — why index tensors need real values during graph warmup
- `GPU_Concepts/tensors.md` — tensor shape/layout basics
