# Regex (Python)

```python
import re

regex = r"(?P<variable>.*) \#(?P<variable_2>\d+)"
match = re.search(regex, "something #2")

variable = match.group("variable")
variable_2 = match.group("variable_2")
```

