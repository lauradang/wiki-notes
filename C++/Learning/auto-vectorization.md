# Auto-Vectorization

## What it is

Your CPU has special registers that are wider than normal. A normal register holds 1 number (32 bits). But modern CPUs have:

- **SSE registers** — 128 bits wide (fit 4 floats)
- **AVX2 registers** — 256 bits wide (fit 8 floats)
- **AVX-512 registers** — 512 bits wide (fit 16 floats)

These come with special instructions that operate on the entire wide register at once. So instead of doing 8 additions one at a time, you do all 8 in a single instruction — same clock cycle.

**Auto-vectorization** means the compiler looks at your loops and tries to automatically rewrite them to use these wide instructions.

---

## Example

```cpp
// What you wrote:
for (int i = 0; i < 8; i++) {
    result[i] = a[i] + b[i];
}
```

### Without vectorization (8 instructions)

```
add  result[0], a[0], b[0]
add  result[1], a[1], b[1]
add  result[2], a[2], b[2]
add  result[3], a[3], b[3]
add  result[4], a[4], b[4]
add  result[5], a[5], b[5]
add  result[6], a[6], b[6]
add  result[7], a[7], b[7]
```

### With auto-vectorization (1 instruction)

```
vaddps  result[0..7], a[0..7], b[0..7]    // all 8 at once
```

Same result, ~8× fewer instructions.

---

## When it works

Auto-vectorization works great for **simple, regular patterns**:
- Adding arrays
- Multiplying arrays
- Element-wise math on contiguous data
- Loops with a known trip count and no early exits

The compiler needs to be able to prove:
1. Iterations are independent (no `result[i]` depending on `result[i-1]`)
2. Memory accesses are contiguous and aligned
3. No conditional branches that would make iterations diverge

---

## When it doesn't (and why)

Auto-vectorization gives up when the loop body has:

- **Irregular bit manipulation** — extracting packed values via shifts/masks
- **Conditional branches** — different code paths per iteration
- **Pointer casting / type punning** — reinterpreting bits as another type
- **Indirect addressing** — `a[index[i]]` instead of `a[i]`
- **Function calls** the compiler can't inline

Example of code that defeats auto-vectorization:

```cpp
// Extract a packed value, then look up scale from a separate array
for (int i = 0; i < n; i++) {
    uint8_t value = (packed[i / 4] >> ((i % 4) * 8)) & 0xFF;
    result[i] = value * scale[lookup[i]];
}
```

The compiler sees irregular bit shifting, indirect indexing via `lookup[i]`, and pointer casting — it can't figure out how to pack that into wide registers. It falls back to one element at a time.

---

## SIMD Intrinsics — when the compiler gives up

If auto-vectorization fails on a hot loop, you can manually write **SIMD intrinsics** — calling the wide instructions directly:

```cpp
#include <immintrin.h>

__m256 va = _mm256_load_ps(&a[0]);     // load 8 floats
__m256 vb = _mm256_load_ps(&b[0]);     // load 8 floats
__m256 vc = _mm256_add_ps(va, vb);     // add all 8 at once
_mm256_store_ps(&result[0], vc);       // store 8 floats
```

**Tradeoffs:**
- ✅ Faster — you control exactly which instructions are used
- ❌ Harder to write — closer to assembly than C++
- ❌ Not portable — AVX2 intrinsics won't run on a CPU without AVX2
- ❌ Harder to maintain — future readers need to understand SIMD

Rule of thumb: try `-O3 -march=native` first. Only reach for intrinsics if profiling shows a hot loop the compiler refused to vectorize.

---

## How to check what the compiler did

Most compilers can report which loops they vectorized:

```bash
# GCC
g++ -O3 -fopt-info-vec-all foo.cpp

# Clang
clang++ -O3 -Rpass=loop-vectorize foo.cpp
```

You'll see messages like `loop vectorized` or `loop not vectorized: complex memory access pattern`. The "not vectorized" reasons tell you what to fix if you want the compiler to succeed.

---

## Related

- See `cxxflags-compiler-flags.md` — `-O3` enables auto-vectorization, `-march=native` lets it use the widest registers your CPU supports
