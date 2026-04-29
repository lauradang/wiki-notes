# fpval — Struct-Based Floating-Point Representation

A custom struct that represents a floating-point number as **separate fields**, instead of using a native `float`.

## What it looks like

Conceptually:

```
class fpval {
    <int>  exp;               // exponent
    <int>  frac;              // fraction / mantissa
    bool   sign;              // sign bit
    <uint> fpMantissaWidth;   // how many bits the mantissa actually uses
};
```

A normal IEEE `float` packs sign + exponent + mantissa into 32 bits and the CPU handles the whole thing as one unit. `fpval` breaks those fields apart into separate integers so the code can manipulate each piece individually — exactly the way the GPU hardware processes them internally.

## Why not just use `float`?

Because this is a **reference model** simulating the GPU's OMMA / HMMA hardware bit-by-bit. The GPU doesn't do IEEE float math — it has its own FP4/FP8 formats with custom rounding, scaling, and accumulation rules. To match the hardware exactly, the model needs to control every bit operation:

- shift the mantissa
- add the exponents
- check for NaN
- handle denorms
- apply the GPU's rounding rule (not IEEE round-to-nearest-even)
- track scaling factors

A native `float` would give different results because the CPU's FP unit follows IEEE rules, not the GPU's custom rules. The whole point of the reference model is to be **bit-exact** with hardware, so IEEE-conformant CPU floats are the wrong tool.

## The cost

Every `a * b` that would be **1 CPU instruction** with native floats becomes ~20 operations on `fpval`:

1. Extract sign / exp / frac fields
2. Multiply mantissas (integer multiply)
3. Add exponents
4. Check for zero
5. Check for NaN / Inf
6. Normalize result
7. Apply custom rounding
8. Pack back into struct

This is why the simulation is slow — and why **SIMD can't help much**. SIMD works best on tight, regular loops with no branches. `fpval` operations are full of conditional branches (NaN check, denorm check, zero check, sign handling), so the compiler can't vectorize them and a GPU SIMT model would diverge constantly.

The slowness is the price of correctness. If you want speed, use native floats; if you want to match silicon bit-for-bit, you eat the ~20× overhead.

## When this pattern shows up

- Reference / "golden" models for hardware verification
- Simulating non-IEEE FP formats (FP8 E4M3 / E5M2, FP4, MX formats)
- Modeling fused operations (HMMA, OMMA, IMMA) where intermediate precision matters
- Anywhere the bit-level result has to match RTL / silicon

## Related

- `GPU_Concepts/floating-point-precision.md` — FP32/FP8/FP4 formats themselves
- `GPU_Concepts/simd.md` — why branchy code defeats vectorization
- `C++/Learning/auto-vectorization.md` — what kind of loops the compiler *can* vectorize (and `fpval` ops aren't them)
