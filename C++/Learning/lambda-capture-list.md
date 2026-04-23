# Lambda Capture List

## Why This Syntax Looks Strange

This:

```cpp
auto readExact = [&file](void* data, size_t bytes) -> bool {
    return true;
};
```

is not a normal function definition.

It is:

- a variable named `readExact`
- assigned to a lambda expression

So:

```cpp
auto readExact = ...
```

means:

"store this callable object in a variable named `readExact`"

That is why it does not look like:

```cpp
bool readExact(...);
```

## Normal Function Vs Lambda

### Normal Function

```cpp
bool readExact(std::ifstream& file, void* data, size_t bytes) {
    return true;
}
```

Here:

- `readExact` is the function name
- the parameters are written after the name

### Lambda Stored In A Variable

```cpp
auto readExact = [&file](void* data, size_t bytes) -> bool {
    return true;
};
```

Here:

- `readExact` is a variable name
- the lambda is the value on the right side of `=`

## What The Capture List Means

The `[]` part is called the capture list.

It tells the lambda which variables from the surrounding scope it is allowed to use.

So:

```cpp
[&file]
```

means:

- use the outer variable `file`
- capture it by reference

That means the lambda refers to the same `file` object from the surrounding function.

## Why C++ Needs This

If a lambda uses a local variable from the outer function, C++ makes you say so explicitly.

Without the capture, using `file` inside the lambda body would be an error.

This explicitness lets C++ distinguish between:

- capture by reference
- capture by value

## Common Capture Forms

```cpp
[]      // capture nothing
[=]     // capture used outer variables by value
[&]     // capture used outer variables by reference
[file]  // capture only file by value
[&file] // capture only file by reference
```

## Parameters Vs Captures

In:

```cpp
[&file](void* data, size_t bytes) -> bool
```

- `[&file]` is the capture list
- `(void* data, size_t bytes)` are the function parameters

So when you call:

```cpp
readExact(ptr, 100);
```

you are passing:

- `ptr`
- `100`

You are not passing `file` there.

`file` was captured earlier when the lambda was created.

## Python Equivalent

The closest Python equivalent is a nested function that closes over an outer variable:

```python
def load_from_file(filename: str) -> bool:
    with open(filename, "rb") as file:
        def read_exact(data: memoryview | bytearray, nbytes: int) -> bool:
            if nbytes == 0:
                return True

            chunk = file.read(nbytes)
            if len(chunk) != nbytes:
                return False

            data[:nbytes] = chunk
            return True

        return True
```

Here, `read_exact` can use `file` from the outer function.

In Python, this happens automatically.

In C++, you must write that explicitly with the capture list.

## Side-By-Side Idea

Python:

```python
def outer():
    file = open("data.bin", "rb")

    def read_exact(nbytes: int) -> bytes:
        return file.read(nbytes)
```

C++:

```cpp
void outer() {
    std::ifstream file("data.bin", std::ios::binary);

    auto readExact = [&file](size_t bytes) {
        // use file here
    };
}
```

Both create a helper that can use `file` from the outer scope.

The difference is that Python closures are implicit, while C++ lambda captures are explicit.

## Short Version

- `auto readExact = ...` means a variable is being assigned a lambda.
- `[&file]` is the capture list.
- It means the lambda may use the outer `file` variable by reference.
- `(void* data, size_t bytes)` are normal parameters passed when calling the lambda.
- The closest Python equivalent is a nested `def` that closes over an outer variable.
