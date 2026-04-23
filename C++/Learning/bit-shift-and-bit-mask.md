# Bit Shift And Bit Mask

## Left shift: `<<`

`<<` is the bitwise left-shift operator.

It moves the bits of a number to the left.

Example:

```cpp
1 << 4
```

Start with:

```text
0001
```

Shift left by 4:

```text
10000
```

That is `16` in decimal.

So:

```cpp
1 << 4
```

means "take `1` and shift it left by 4 bit positions."

## Example from code

```cpp
const unsigned lutb_element_mask = (1 << lutb_element_width_bits) - 1;
```

This means:

"create a mask with `lutb_element_width_bits` number of `1`s."

If `lutb_element_width_bits = 4`, then:

```cpp
(1 << 4) - 1
```

Step by step:

```text
1       = 0001
1 << 4  = 10000
10000 - 1 = 01111
```

`01111` is `15` in decimal.

So the result is:

```cpp
lutb_element_mask = 15;
```

## Why this is useful

A value like:

```text
1111
```

is a bit mask.

It can be used to keep only the lowest 4 bits of a number.

Example:

```cpp
value & 0b1111
```

This means:

"throw away all bits except the lowest 4."

## General pattern

```cpp
(1 << n) - 1
```

means:

"make a mask with `n` ones."

Examples:

- `n = 3` gives `0b111`
- `n = 4` gives `0b1111`
- `n = 8` gives `0b11111111`
