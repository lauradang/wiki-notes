# Nested Dictionaries

Use case: When we are querying from an API, the JSONs can be very nested and can get messy. Here's what I mean:

```python
json["field"]["field1"]["field2"] # Messy!

# What about this instead?
json.field.field1.field2 # Not messy :)
```

Example:

```python
# pip install attrdict
from attrdict import AttrDict

# json: dict
json = AttrDict(json)
json.field.field1.field2 # possible now
```

Extension:

We can use a dataclass like so to make this even cleaner.

```python
from dataclasses import dataclass
from dataclasses import field
import operator

from attrdict import AttrDict


@dataclass
class ExampleClass:
    a: str = field(metadata={"api_key": "field1"})
    b: str = field(metadata={"api_key": "field1.field2.field3"})
        
        
json = request.get(...).json()
json = AttrDict(json)

for field in fields(ExampleClass):
    api_key = field.metadata["api_key"]
    
    # Can do this:
    api_value = operator.attrgetter(api_key)(json)
    # OR this:
    api_value = eval(f"json.{api_key}")
    
    # Both of these probably need try-excepts for AttributeError
```

