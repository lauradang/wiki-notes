# Context Manager

When you have a lot of context managers, you can use `ExitStack()` to make it more neat.

```python
from contextmanager import ExitStack

with ExitStack() as context_stack:
    context_1 = context_stack.enter_context(self.context_1)
    context_2 = context_stack.enter_context(self.context_2)
    context_3 = context_stack.enter_context(self.context_3)
```

is equivalent to

```python
with self.context_1 as context_1, self.context_2 as context_2, self.context_3 as context_3:
  ...
```