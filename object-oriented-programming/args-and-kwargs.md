# Args and Kwargs

Args returns a tuple while kwargs returns a dict

```python
def hello(*args, **kwargs):
  print(args)
  print(kwargs)

hello("L", greeting="Hi")

>> ("L", )
>> {'greeting':"Hi"}
```

```python
def hello(*args, **kwargs):
    gretting = kwargs.pop('greeting', 'Hello')

    print(f"""{gretting} {' '.join(args)}!""")


>> hello("Laura", "Dang", gretting="Hi")

# returns `Hi Laura Dang!`.
```

