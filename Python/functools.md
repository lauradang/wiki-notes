# Functools

## `wraps`

SUMMARY: We use `@wraps(func)` to preserve the information of a decorator.

```python
def my_decorator(func):
    def wrapper(*args, **kwargs):
        print("Hi")
        return func(*args, **kwargs)
    return wrapper

@my_decorator
def add(x, y):
    """add x and y"""
    return x + y

>> add(1,2)
Hi
3

>> add.__name__
'wrapper' # does not return 'add' because when the function was executing, it was inside wrapper()

>> add.__doc__
# does not return anything because wrapper() has no doc
```

So how do we get the actual function information and not the `wrapper()`. We can use `@wraps` for this:

```python
def my_decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print("Hi")
        return func(*args, **kwargs)
    return wrapper

@my_decorator
def add(x, y):
    """add x and y"""
    return x + y

>> add(1,2)
Hi
3

>> add.__name__
'add'

>> add.__doc__
'add x and y'
```