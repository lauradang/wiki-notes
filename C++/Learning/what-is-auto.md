# What Is auto

## Definition

In C++, `auto` means:

"let the compiler deduce the type from the initializer"

So in:

```cpp
auto x = 42;
```

the compiler deduces that `x` is an `int`.

## Basic Examples

```cpp
auto x = 42;           // int
auto y = 3.14;         // double
```

This is also common with iterators:

```cpp
auto it = values.begin();
```

Without `auto`, the iterator type can be long and noisy.

## Lambdas

`auto` is especially useful with lambdas.

```cpp
auto readExact = [&file](void* data, size_t bytes) -> bool {
    return true;
};
```

Here, `readExact` is assigned a lambda.

Each lambda has its own unique, unnamed type, so `auto` is the normal way to store one in a variable.

## What auto Is Not

`auto` does not make C++ dynamically typed.

It is not like Python where a variable name can later refer to values of unrelated types during normal use.

In C++, the deduced type is still fixed at compile time.

So:

```cpp
auto x = 42;
```

means `x` is an `int`, not "whatever type gets assigned later".

## Why Use auto

- shorter code
- useful for long iterator or template-heavy types
- necessary or natural for lambdas
- avoids repeating obvious type information

## Rule Of Thumb

Use `auto` when:

- the type is obvious from the right-hand side
- the explicit type would be overly verbose

Use an explicit type when:

- you want the exact type to be immediately visible to the reader
- the deduced type might be surprising

## Short Version

- `auto` asks the compiler to infer the type.
- The type is still decided at compile time.
- It is commonly used for iterators and lambdas.
- It improves readability when the type is obvious or too verbose.
