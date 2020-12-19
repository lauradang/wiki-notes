# Dataclasses

Consider using these over classes when your class primarily has fields, and not methods.

https://docs.python.org/3/library/dataclasses.html

```python
from dataclasses import dataclass
from dataclasses import field

@dataclass
class ExampleClass:
    a: int
    b: int = field(init=False)

    def __post_init__(self): # This is for any postprocessing of the fields that is needed
       	self.b = self.a

obj = ExampleClass(1) # self.a = 1
print(obj)
>> ExampleClass(1, 1) # self.b = 1
```

