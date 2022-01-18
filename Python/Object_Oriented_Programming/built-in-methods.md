# Built-in Methods

## `__call__()`

```python
In [1]: class A:
   ...:     def __init__(self):
   ...:         print "init"
   ...:
   ...:     def __call__(self):
   ...:         print "call"
   ...:
   ...:

In [2]: a = A()
init

In [3]: a()
call
```

This is where the `object is not callable` error comes from:

```python
>>> class A:
...     def __init__(self):
...             print("hi")
...
>>> a = A()
hi
>>> a()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'A' object is not callable
>>> exit()
```