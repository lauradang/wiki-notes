# Tensors

A **tensor** is a generalization of scalars / vectors / matrices to **arbitrary numbers of dimensions**.

## The dimension ladder

| Name | Dimensions ("rank") | Shape example |
|---|---|---|
| Scalar | 0-D | `5.0` |
| Vector | 1-D | `[3, 1, 4]` |
| Matrix | 2-D | `[[1, 2], [3, 4]]` |
| Tensor (rank-3) | 3-D | a stack of matrices, e.g. RGB image of size H × W × 3 |
| Tensor (rank-N) | N-D | any number of axes |

Technically, scalars, vectors, and matrices are all tensors — just low-rank ones. In practice, when people say "tensor" they usually mean **rank ≥ 3** (or, in deep-learning code, "any multi-dim array").

## What it really is in code

Stripped of the physics/math baggage, a tensor in a GPU / ML context is just:

- a **contiguous block of memory**
- a **shape** (e.g. `[64, 128, 32]`)
- a **dtype** (FP4, FP8, FP16, FP32, INT8, …)
- optionally a **layout / stride pattern** (row-major vs column-major vs blocked)

That's it. Mathematically a tensor has more structure (transformation rules under coordinate change), but in hardware/ML work it's "an N-dimensional array with a known shape and type."

## Common shapes you'd see

- **Image batch:** `[batch, channels, height, width]` → 4-D tensor
- **Transformer activations:** `[batch, sequence_length, hidden_dim]` → 3-D tensor
- **Weight matrix:** `[in_features, out_features]` → 2-D tensor
- **Single token's embedding:** `[hidden_dim]` → 1-D tensor (a vector)

## Why GPUs are obsessed with them

The whole reason GPUs ship with **tensor cores** (and now ultra-tensor cores) is that the dominant workload on a modern GPU is:

```
D = A × B + C
```

…where A, B, C, D are matrices (rank-2 tensors). At scale — across batches, heads, layers — these become rank-3 or rank-4 tensor operations. The hardware specializes in fused matrix-multiply-accumulate at custom precisions because that's what neural networks are made of.

**Tensor memory** is on-chip storage designed to hold the operands of these matrix-multiply tiles efficiently — addressed in slices/columns/subpartitions, with hardware support for the specific layouts the tensor cores want.

## TL;DR

A tensor is an N-dimensional array. In GPU / ML work it's almost always a 2-D or 3-D tile of low-precision values (FP4/FP8/FP16), sitting in tensor memory, about to be fed into a matrix-multiply-accumulate instruction.

## Related

- `GPU_Concepts/floating-point-precision.md` — the FP4/FP8/FP16 formats tensors usually carry
- `GPU_Concepts/fpval.md` — modeling tensor elements bit-exactly in a reference shader
- `GPU_Concepts/Datapaths_and_DP_Organization.md` — how a tensor tile is sliced across subpartitions
