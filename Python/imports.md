# Imports

## Importing variables/functions without executing the code

```python
# file1
test = "hello"
def main():
  pass

if __name__ == "__main__":
  c = "hello"
 	main()
  
# file2
from file1 import test
>> Main will not run!
```

**Note**: You cannot import `c` into `file2` since the `if __name__ == __main__` block is only executed when you run the Python program **DIRECTLY**. So technically, when you do imports, `c` is not even defined.

## Importing Functions that Contain Global Variables

- Global variable in the file where the functions lives is what the variable will be defined as

```python
# file: test.py
thing1 = 1
def hello():
  print(thing1)
  
# file: test1.py
from test import hello
thing1 = 4
hello()

# Running python3 test1.py
>> 1
```

