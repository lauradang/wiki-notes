# Declaration vs. Definition

In C++, a function (or class, or global variable) can be **declared** many times, but must be **defined** exactly once. Knowing which one you're looking at is the difference between "this function exists somewhere" and "this is its actual code."

## How to tell — at a glance

The give-away is the **trailing semicolon and the absence of a function body**:

```cpp
inline void loadCMatrix(
    ...parameters...
);   // ← semicolon, no { }
```

That's a declaration.

| Form | What it is |
|---|---|
| `void foo(int x);` | **Declaration** — "a function `foo` exists somewhere; here's its signature" |
| `void foo(int x) { ... }` | **Definition** — "and here's what it actually does" |

If you see `;` immediately after the `)`, it's a declaration. If you see `{ ... }`, it's a definition.

## What a declaration buys you

A declaration tells the compiler the function's name, return type, and parameter list. That's enough for any code that **calls** the function to compile — the compiler can type-check the call without ever seeing the body.

The actual body — the code that walks tmem, unpacks slices, fills the buffer, whatever — lives **somewhere else**, almost certainly in another header or `.cpp` file.

At **link time**, the linker connects calls to the function's name to whichever translation unit provides the definition. If no translation unit defines it, you get an "undefined reference" link error.

## Same idea for other entities

```cpp
// Functions
void foo();              // declaration
void foo() { /*...*/ }   // definition

// Global variables
extern int counter;      // declaration ("it exists, defined elsewhere")
int counter = 0;         // definition

// Classes
class Matrix;            // forward declaration ("Matrix is a class — details TBD")
class Matrix {           // definition
    int rows, cols;
};
```

A **forward declaration** of a class is enough if all you need is to use pointers/references to it. You only need the full definition when you have to know its size or access its members.

## Why C++ separates them

Because C++ compiles each `.cpp` file into its own object file independently, then the linker stitches them together. Declarations let you use a function in many `.cpp` files without each one needing to see the source. Headers exist exactly to spread declarations around — definitions usually live in one `.cpp`.

This separation is also what powers the **One Definition Rule**: the linker enforces that there's exactly one definition program-wide for free functions and globals (with `inline` carving out the exception for header-only definitions — see `cxxflags-compiler-flags.md` and below).

## Quick wrinkle: `inline`

When you see `inline` on a declaration:

```cpp
inline void loadCMatrix(...);
```

It signals that the function's **definition** is expected to be visible to every translation unit that calls it (typically in the same header or in an `.inl` / `_impl.h` file `#include`d at the bottom). `inline` lets the same definition appear in multiple `.cpp` files without violating the One Definition Rule.

## Finding the definition for a given declaration

If you have a declaration in front of you and want to find the body:

```bash
grep -rn "loadCMatrix(" path/to/code/   # look for the one with { not ;
```

You're filtering for the version that ends in `{` rather than `;`.

## Related

- `C++/Learning/cxxflags-compiler-flags.md` — flags and how compilation/linking are separate steps
- `C++/Learning/auto-vectorization.md` — example of header-defined inline functions
