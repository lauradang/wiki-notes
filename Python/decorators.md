# Decorators

## Fundamentals

[Python Decorators in 15 Minutes](https://www.youtube.com/watch?v=r7Dtus7N4pI)

Say we have

```python
def f1():
    print("called f1")

f1
>> <function f1 at 0x008EEDF8>
```

`f1` is actually an **object** at some memory address in Python. So we can actually pass functions around (since they are objects) into functions, store it in variables, etc.

```python
def f1():
    print("called f1")

def f2(f):
    f()

f2(f1)
>> called f1
```

## Example

```python
def my_decorator(func):
    def wrapper():
        print("Before")
        func()
        print("After")
    return wrapper

def say_whee():
    print("Whee!")

# This is function aliasing
say_whee = my_decorator(say_whee)

'''
>> say_whee()
Before
Whee!
After
'''

## Equivalent to above - decorators make function aliasing nicer
@my_decorator
def say_whee():
    print("Whee!")

'''
>> say_whee()
Before
Whee!
After
'''
```
To remember easier, remember decorator is a function that wraps a function and takes in the function below it as an argument.

## Decorating Functions with Arguments

```python
def my_decorator(func):
    def wrapper(*args, **kwargs):
        print("Before")
        func(*args, **kwargs)
        print("After")
    return wrapper

@my_decorator
def say_whee(a): # now that we have a parameter here, wrapper() and func() need to have inputs as well, so we use args and kwargs
    print(a)

say_whee("Whee!")
```

We use args and kwargs because we have no idea what arguments will be passed into the function. So this allows us to have any arguments or number of arguments in the function.

## Returning values from decorators

```python
def my_decorator(func):
    def wrapper(*args, **kwargs):
        print("Before")
        val = func(*args, **kwargs)
        print("After")
        return val
    return wrapper

@my_decorator
def add(x, y):
    return x + y

>> print(add(4,5))
Before
After
9
```

## Decorators with Arguments

https://www.artima.com/weblogs/viewpost.jsp?thread=240845#decorator-functions-with-decorator-arguments

```python
def decoratorFunctionWithArguments(arg1, arg2, arg3):
    def wrap(f):
        print "Inside wrap()"
        def wrapped_f(*args):
            print "Inside wrapped_f()"
            print "Decorator arguments:", arg1, arg2, arg3
            f(*args)
            print "After f(*args)"
        return wrapped_f
    return wrap

@decoratorFunctionWithArguments("hello", "world", 42)
def sayHello(a1, a2, a3, a4):
    print 'sayHello arguments:', a1, a2, a3, a4

print "After decoration"

print "Preparing to call sayHello()"
sayHello("say", "hello", "argument", "list")
print "after first sayHello() call"
sayHello("a", "different", "set of", "arguments")
print "after second sayHello() call"
Here's the output:

Inside wrap()
After decoration
Preparing to call sayHello()
Inside wrapped_f()
Decorator arguments: hello world 42
sayHello arguments: say hello argument list
After f(*args)
after first sayHello() call
Inside wrapped_f()
Decorator arguments: hello world 42
sayHello arguments: a different set of arguments
After f(*args)
after second sayHello() call
```