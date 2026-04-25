# 🧠 Floating Point (FP32 vs FP8 vs FP4) — Full Intuition + Examples

## Big Picture

Floating-point numbers are stored as:

value = sign × mantissa × 2^exponent

- **Sign** → positive or negative
- **Mantissa (significand)** → precision (the actual digits)
- **Exponent** → scale (how big or small the number is)

---

## 🔢 Example: Storing a Number

Let's take:

x = 6.75

In binary scientific notation:

6.75 = 1.6875 × 2²

So:
- Mantissa = 1.6875
- Exponent = 2

---

## 🧩 FP32 (Standard Float)

Structure:
- 1 sign bit
- 8 exponent bits
- 23 mantissa bits

### What "8 exponent bits" means
- 8 bits = 256 possible values
- Uses a bias of 127:

actual_exponent = stored_value - 127

Example:
stored = 129 → actual exponent = 2

### Result
6.75 → stored almost exactly

✅ Huge range
✅ High precision

---

## ⚖️ FP8 (Reduced Precision)

Typical structure:
- 1 sign
- ~4–5 exponent bits
- ~2–3 mantissa bits

### Example

6.75 ≈ 1.6875 × 2²

With limited mantissa:

1.6875 → 1.75 (rounded)

So:

6.75 → 1.75 × 2² = 7.0

👉 Small error, still usable

---

## ⚠️ FP4 (Very Low Precision)

Typical structure:
- 1 sign
- ~2 exponent bits
- ~1 mantissa bit

Only ~16 possible values total.

Example values:
{0, ±0.5, ±1, ±2, ±4, ±8}

### Example

6.75 → 8 (closest value)

👉 Large error (~18%)

---

## 🔑 Mantissa vs Exponent

- **Mantissa = precision (detail)**
- **Exponent = range (scale)**

### Analogy
- Mantissa → image sharpness
- Exponent → zoom level

---

## 🚀 Why Low Precision Works in ML

Matrix multiply:

C[i][j] = Σ A[i][k] × B[k][j]

---

### 1) Neural Nets Tolerate Noise
Small rounding errors don't break results.

---

### 2) Higher Precision Accumulation

Even with low precision inputs:

low_precision × low_precision → accumulate in FP16/FP32

Prevents large error buildup.

---

### 3) Scaling (Key Trick)

Instead of storing raw values:

real_value ≈ quantized_value × scale

---

### Example: Scaling

Original:
[5.9, 6.75, 7.1]

Choose:
scale = 0.5

Transform:
[11.8, 13.5, 14.2] → quantize → [12, 14, 14]

Recover:
[6.0, 7.0, 7.0]

👉 Much better approximation

---

## 🧮 Matmul Example

True result:

A = [6.75, 2.1]
B = [1.2, 3.3]

6.75×1.2 + 2.1×3.3 = 15.03

---

### FP4 Approximation

A ≈ [8, 2]
B ≈ [1, 4]

Compute:
8×1 + 2×4 = 16

👉 ~6% error (acceptable in ML)

---

## ⚡ Why GPUs Prefer FP8 / FP4

### 1) Memory
- FP32 = 4 bytes
- FP8 = 1 byte
- FP4 = 0.5 bytes

→ 4–8× more data loaded per cycle

---

### 2) Speed
- More operations per cycle
- Optimized hardware (tensor cores)

---

### 3) Cache Efficiency
- Smaller data → better reuse

---

## 🧠 Final Mental Model

- **FP32** → accurate number
- **FP8** → rounded number
- **FP4** → rough bucket + scaling fixes it

---

## 🔁 One-Line Takeaway

Floating point = **precision (mantissa)** × **range (exponent)**
ML trades precision for speed using **scaling + high-precision accumulation**.

---

## ➕ How Floating-Point Addition Actually Works (Exponent Alignment)

You can't add two floats by just adding their fraction parts — the exponents have to match first.

### Quick refresher: how a float is stored

```
sign | exponent | fraction
  1  | 01111100 | 01000000000000000000000
```

This represents: `(-1)^sign × 1.fraction × 2^(exponent - bias)`

So `6.5` is stored as `1.625 × 2^2` — exponent is `2`, fraction encodes `1.625`.

### The problem

It's like adding in scientific notation:

```
  1.5 × 10^5    (150,000)
+ 3.2 × 10^2    (320)
```

You can't just add `1.5 + 3.2` — that gives the wrong answer. You first line up the decimal points by making the exponents match:

```
  1.5000 × 10^5
+ 0.0032 × 10^5    ← shifted 3.2 right by 3 places
= 1.5032 × 10^5
```

### Equalize exponents

That's the operation: **pick the largest exponent, shift everyone else's fraction right to align with it, then add the fractions.**

In a matrix multiply, after multiplying A×B elements you get many products that need to be summed. Each product may have a different exponent. Before accumulating, they all have to be equalized.

This is why FP addition is more expensive than integer addition — and why GPU hardware has dedicated circuits for it. On a CPU simulating that hardware, exponent alignment can dominate runtime.

### Why this connects back to FP8/FP4

This is also why low-precision **multiplication** can keep input precision low but accumulate in higher precision — the alignment + sum step is where errors compound, so you give that step more bits to work with.
