# Logging

Properly colouring and formatting logs:

```python
import logging

# pip install rich
from rich.logging import RichHandler


FORMAT = "%(message)s"
logging.basicConfig(
    level="INFO", format=FORMAT, datefmt="[%X] ", handlers=[RichHandler()]
)

logger = logging.getLogger("rich")
```

Now, you can import `logger` into any file and call: `logger.info`, `logger.error`, `logger.debug`, etc.

If you want to see debug messages, you need to change the `logging.basicConfig` level parameter to `"DEBUG"`

