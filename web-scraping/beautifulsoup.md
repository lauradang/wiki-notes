# BeautifulSoup

## Set up

```python
from bs4 import BeautifulSoup
import requests

source_start = requests.get(url)
soup = BeautifulSoup(source_start.text, 'lxml')
```

## Removing style tags

```python
[s.extract() for s in soup('style')]
```

