# CXXFLAGS — C++ Compiler Flags

## What are CXXFLAGS?

C++ source code is human-readable text. The CPU can't run it directly — it needs to be translated into machine code (binary instructions). The **compiler** (e.g. `g++`) does that translation.

`CXXFLAGS` is just a Makefile variable holding the options passed to the C++ compiler. Think of it like camera settings — the camera (compiler) takes the picture (builds the binary) either way, but the settings change *how* it does it.

```make
CXXFLAGS = -std=c++20 -O3 -march=native -flto -Wall
```

Each `-something` is a flag.

---

## `-std=c++20`

Tells the compiler which version of the C++ language to use.

C++ evolves over time. C++20 is the 2020 version of the standard, with newer language features. If your code uses C++20 features, you need this flag or the compiler rejects the code.

**Speed impact: none.** It only controls which language features are allowed.

---

## `-O2` vs `-O3` (the big one)

`-O` stands for **Optimize**. The number is the aggressiveness level.

The compiler doesn't have to translate code literally line by line. It can rearrange things to make the result faster, as long as observable behavior stays the same.

### Example

```cpp
for (int i = 0; i < 4; i++) {
    result[i] = a[i] + b[i];
}
```

**`-O0` (no optimization):** Translates literally — loop 4 times, do one addition each, check the loop counter each time. Slow but easy to debug.

**`-O2` (good optimization):**
- Keep `a[i]` and `b[i]` in CPU registers instead of re-reading from memory
- Remove loop counter checks if provably unnecessary
- Reorder instructions so the CPU doesn't stall waiting for memory

**`-O3` (aggressive):** Everything in `-O2`, plus:

- **Auto-vectorization** — modern CPUs have wide registers (AVX/SSE) that process 4 or 8 numbers in a single instruction. The compiler rewrites your loop to use them:
  ```
  // Instead of 4 separate adds:
  add result[0], a[0], b[0]
  add result[1], a[1], b[1]
  add result[2], a[2], b[2]
  add result[3], a[3], b[3]

  // It does one wide add:
  vadd result[0..3], a[0..3], b[0..3]   // all 4 at once
  ```
- **More inlining** — when function A calls function B, there's overhead (push args, jump, return). Inlining pastes B's code directly into A. `-O3` inlines more aggressively.
- **Loop unrolling** — instead of looping 100 times doing 1 thing, write out 4 iterations and loop 25 times. Reduces "am I done?" checks.

`-O3` matters most when you have millions of small function calls and tight loops over small arrays — exactly the patterns it optimizes best.

---

## `-march=native`

"Use whatever instructions this specific CPU supports."

Different CPUs support different instruction sets:
- A 2010 CPU might only have SSE4 (4 floats at once)
- A modern CPU might have AVX2 (8 floats) or AVX-512 (16 floats)

By default the compiler plays it safe and uses the lowest common denominator so the binary runs anywhere. `-march=native` says "I'm only running this on this machine, use everything it has."

**Tradeoff:** the binary may not run on older hardware.

---

## `-flto` (Link-Time Optimization)

### How compilation normally works

A C++ project has multiple `.cpp` files. The compiler processes each independently:

```
file_a.cpp  →  [compile]  →  file_a.o
file_b.cpp  →  [compile]  →  file_b.o
file_c.cpp  →  [compile]  →  file_c.o
```

Then the linker glues all `.o` files into the final binary:

```
file_a.o + file_b.o + file_c.o  →  [link]  →  final_binary
```

**The problem:** while compiling `file_c.cpp`, the compiler sees a call to a function that lives in `file_a.cpp`. It can't inline it or optimize across that boundary — it just emits a call instruction.

### What `-flto` changes

Instead of fully compiling each file to machine code, the compiler saves an intermediate representation. At link time it re-optimizes everything together as if all the code were in one giant file:

```
file_a.cpp  →  [partial compile]  →  file_a.lto
file_b.cpp  →  [partial compile]  →  file_b.lto
file_c.cpp  →  [partial compile]  →  file_c.lto

ALL .lto files  →  [optimize together + link]  →  final_binary
```

Now the compiler can inline functions across file boundaries. If a hot function in one file is called millions of times from another file, eliminating call/return overhead adds up significantly.

Often the **biggest contributor** to cross-module speedups, since hot functions usually live in separate library files from their callers.

---

## `-Wall`

Turns on all warnings. The compiler prints a message for anything suspicious (unused variables, possible bugs, etc.).

**Speed impact: none.** Pure code-quality. Good practice to always have it on.

---

## Summary

| Flag | What it does | Speed impact |
|---|---|---|
| `-std=c++20` | Use C++20 language features | None |
| `-O3` | Aggressive optimization (vectorize, inline, unroll) | Big |
| `-march=native` | Use all CPU instructions on this machine | Moderate |
| `-flto` | Optimize across file boundaries at link time | Big |
| `-Wall` | Show all compiler warnings | None |
