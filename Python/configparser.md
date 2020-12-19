# Configparser

https://docs.python.org/3/library/configparser.html

A way to handle credentials properly in Python. 

**Remember**: Put the credentials file in your .gitignore.

Example `config.cfg`:

```ini
[some-db-service]
user = user
pass = password
host = db_host
port = 3306
database = database

[some-api-service]
user = user
pass = pass
token = token
```

```python
import configparser
from typing import Union

from logger import logger

CONFIG_FILE = "config.cfg"


class Handler:
    def __init__(self):
        self.config_file = CONFIG_FILE
        self.config = configparser.ConfigParser()

    def get_credentials(self, service: str) -> Union[dict, None]:
        """Returns the credentials in the config file of a given service"""
        self.config.read(self.config_file)

        try:
            return self.config[service]
        except KeyError:
            logger.error("Could not read %s from %s", service, self.config_file)
            return None
```

