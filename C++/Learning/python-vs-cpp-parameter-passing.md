# Python Vs C++ Parameter Passing

## Why This Feels Different

In Python, function arguments behave like names bound to objects.

If a function does:

```python
def func(x: str) -> None:
    x = "hi"
```

then `x = "hi"` only rebinds the local name `x`. It does not update the caller's variable.

So if:

```python
y = "no"
func(y)
```

then `y` is still `"no"` after the function call.

## What Is Happening In Python

At the start of the call:

- `y` refers to `"no"`
- `x` also refers to `"no"`

After:

```python
x = "hi"
```

- `x` now refers to a different string
- `y` still refers to the original string

The important distinction is:

- rebinding a local name
- mutating an object in place

For immutable objects like strings, Python gives you rebinding, not in-place modification.

## Python Mutation Example

With a mutable object, the caller can observe the change:

```python
def add_item(values: list[int]) -> None:
    values.append(1)

items = [0]
add_item(items)
```

Now `items` becomes `[0, 1]` because the same list object was mutated.

If instead the function does:

```python
def replace(values: list[int]) -> None:
    values = [1, 2, 3]
```

then the caller's variable does not change, because the local name was rebound.

## C++ Comparison

In C++, this is usually explained in terms of:

- pass by value
- pass by reference
- mutability of the object

### Pass By Value

```cpp
#include <string>

void func(std::string x) {
    x = "hi";
}
```

If you call:

```cpp
std::string y = "no";
func(y);
```

then `y` is still `"no"` because `x` is a copy.

This is the closest C++ equivalent to your Python example in terms of observable behavior.

### Pass By Reference

```cpp
#include <string>

void func(std::string& x) {
    x = "hi";
}
```

Now:

```cpp
std::string y = "no";
func(y);
```

`y` becomes `"hi"` because `x` is an alias for the caller's variable.

## Big Difference Between Python And C++

In Python:

- the function gets a local name bound to the same object
- assignment to that local name does not rebind the caller's name

In C++ pass-by-reference:

- the parameter can be another name for the caller's variable itself
- assignment through that reference can change the caller's object

So Python's argument passing is not the same as C++ reference parameters.

## Strings Being Immutable

Python strings are immutable.

That means you cannot change the existing string object in place.

This:

```python
s = "a"
s += "b"
```

creates a new string with value `"ab"` and then rebinds `s` to it.

It does not expand the original string object in place.

You can see this idea more clearly here:

```python
a = "x"
b = a
a += "y"
```

After this:

- `a` is `"xy"`
- `b` is still `"x"`

because `a` was rebound to a new string.

## C++ Strings Are Different

In C++, `std::string` is mutable:

```cpp
#include <string>

int main() {
    std::string s = "a";
    s += "b";
}
```

After this, `s` contains `"ab"`.

Conceptually, C++ lets you modify the string object. Python treats strings as values that must be replaced with a new string instead.

## Short Version

- Python assignment to a parameter only changes the local name.
- Mutating a mutable Python object can affect the caller.
- Python strings are immutable, so operations like `+` or `+=` make new strings.
- C++ pass-by-value makes a copy.
- C++ pass-by-reference can modify the caller's object directly.
