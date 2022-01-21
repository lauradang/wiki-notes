# Singletons

Used when we only want one instance throughout the entire program's lifespan.

```python
class MySingleton(object): # object because we are inheriting from the baseclass object

    _instance = None
    def __new__(self):
        if not self._instance:
            self._instance = super(MySingleton, self
                                   ).__new__(self)
            self.y = 10
        return self._instance

x = MySingleton()
```
What's happening above?
- Storing definition of class in memory
- when `MySingleton()` is called, it checks to see if `_instance` has been set, and if not, then we actually create an instance and create it
- Result: Only one instance is ever created

```python
print(x.y)
>> 10

x.y = 20
z = MySingleton()
print(z.y)
>> 20
```

## Singleton as Decorator

```python
def singleton(myClass):
    instances = {}
    def getInstance(*args, **kwargs):
        # If there is not already an instance of that class in the dictionary instances, then we create it
        if myClass not in instances:
            instances[myClass(*args, **kwargs)]
        return instance[myClass]
    return getInstance

@singleton
class TestClass(object):
    pass

x = TestClass()
```