# CUDA Graphs

A **CUDA graph** records a sequence of GPU kernel launches once, then replays the whole sequence with a single CPU call — removing per-launch CPU overhead.

## The problem it solves

Every PyTorch op becomes a **kernel launch** sent from the CPU (each costs a few µs). When kernels are short, the GPU sits idle waiting for the next launch.

```
Without graphs:   CPU ─launch─▶ k1   ─launch─▶ k2   ─launch─▶ k3  ...  (GPU idles between)
With a graph:     CPU ─replay(graph)─▶ k1 k2 k3 ...                   (back-to-back)
```

## What gets recorded: kernel + raw addresses

A kernel doesn't know what a "tensor" is — it receives raw GPU memory addresses of the **data** it reads and writes:

```python
y = torch.relu(x)
# becomes, on the GPU:
relu_kernel(input_ptr=0x...1000, output_ptr=0x...9000, n=4096)
#           └── which code ─┘ └──────── which data ────────┘
```

The graph stores each launch **with its arguments frozen** — including those pointers and sizes. That's where the speedup comes from: replay skips Python, kernel selection, shape checks, and allocation.

- Analogy: a spreadsheet macro with **absolute** cell references — instant to replay, but always reads `B3`. To run on new data, paste it into `B3` first.
- CUDA can edit a recorded graph's arguments, but doing so every step costs CPU time and cancels out the gain — PyTorch copies into fixed buffers instead.

## Consequences

| Constraint | Why | How Megatron handles it |
|---|---|---|
| Inputs must live at fixed addresses | Pointers are frozen | **Static input buffers**; each step copies the real batch *into* them (`buf.copy_(x)`, never reassign) |
| Intermediates must never be reused by others | Their addresses are frozen too | A reserved memory pool (`CudaGraphManager.global_mempool`) |
| Shapes are fixed | Sizes like `n=4096` are frozen | One graph per shape, or pad to the recorded size |

## Megatron's capture lifecycle

`megatron/core/transformer/cuda_graphs.py`:

1. **Record** — first eager call (`record_graph_capture`). Each tensor arg is replaced by an `ArgMetadata` (shape / dtype / device, *no values*).
2. **Allocate** — `create_cudagraphs()` → `alloc_tensor_from_graph_mempool(meta)` creates each static buffer with `meta.zeros_like()` — **zero-filled**.
3. **Warmup** — run forward + backward on (clones of) those buffers so libraries do one-time setup outside the recording. `is_graph_warmup()` is `True` here.
4. **Capture** — record the graph.
5. **Replay** — every step: copy the real inputs into the static buffers, replay.

## Gotcha: zero-filled buffers during warmup

Warmup runs on placeholder **zeros**. That's harmless for activations (garbage math nobody uses), but **not for tensors used as indices** — e.g. packed-sequence boundaries (`cu_seqlens`). All-zero offsets can drive index math out of bounds → device-side assert → crash before capture.

Real example (Megatron PR #8124, Oct 2026): TE 2.19's context-parallel attention backward started computing a padding mask from `cu_seqlens_padded`. With `[0, 0, 0, 0]` every token mapped to "sequence 3" and indexed `cu_seqlens[4]` on a length-4 tensor → crash. The fix copies the **recorded real values** of `PackedSeqParams` tensors into the static buffers before warmup. (An earlier, similar bug hit Mamba's `seq_idx`.)

## Related
- `GPU_Concepts/cuda-basics.md` — kernels, launches, and GPU memory that graphs build on
- `Work/Megatron/packed-thd-sequences.md` — the `cu_seqlens` index tensors that break on zero-filled buffers
- `Work/Megatron/context-parallelism.md` — the code path where that warmup crash surfaced
