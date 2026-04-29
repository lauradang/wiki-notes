# SIMD

**Single Instruction, Multiple Data** — one instruction operates on many data elements at once, instead of processing them one at a time.

## The idea

Adding two arrays of 8 numbers:

- **Scalar:** 8 separate add instructions, one per pair.
- **SIMD:** 1 add instruction operating on all 8 pairs in parallel inside a wide register.

Same result, ~8× fewer instructions. The hardware already exists in modern CPUs and GPUs — SIMD is one of the cheapest ways to get throughput.

## Where you see it

### CPUs — wide registers

Modern x86 CPUs ship with progressively wider SIMD registers:

| Instruction set | Register width | Floats per op |
|---|---|---|
| SSE | 128 bits | 4 |
| AVX2 | 256 bits | 8 |
| AVX-512 | 512 bits | 16 |

ARM has its own equivalents: NEON (128 bits) and SVE (variable width).

A loop like `for (i...) result[i] = a[i] + b[i]` becomes a single `vaddps` instruction touching 8 lanes at once. See `auto-vectorization.md` — that's the compiler doing SIMD for you automatically.

### GPUs — SIMT

GPUs are SIMD at massive scale. NVIDIA calls its variant **SIMT** (Single Instruction Multiple Threads): a warp of 32 threads executes the same instruction across 32 data lanes in lockstep.

The difference from pure SIMD is **divergence handling** — if threads in a warp take different branches, the GPU executes both paths and masks off the lanes that shouldn't run. Pure CPU SIMD has no such mechanism; the compiler/programmer must avoid divergence themselves.

So:

- **CPU SIMD** — explicit lanes, no divergence support, great for tight regular loops.
- **GPU SIMT** — implicit lanes (one per thread), handles divergence at a performance cost.

## When SIMD wins

- Element-wise math on contiguous arrays
- Independent iterations (no `result[i]` depending on `result[i-1]`)
- Aligned, contiguous memory access
- No conditional branches that diverge per iteration

## When SIMD breaks down

- Irregular memory access (`a[index[i]]`)
- Pointer chasing
- Heavy branching with per-element divergence
- Loop-carried dependencies

On CPUs the compiler just gives up and emits scalar code. On GPUs you still run, but divergent warps are slow because the hardware serializes the branches.

## Related

- `GPU_Concepts/cuda-basics.md` — warps, threads, the SIMT execution model
- `GPU_Concepts/cpu-vs-gpu.md` — why GPUs lean so heavily on SIMD-style parallelism
- `C++/Learning/auto-vectorization.md` — letting the compiler emit CPU SIMD for you
