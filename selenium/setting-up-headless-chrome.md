# Setting Up Headless Chrome

```python
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException

option_chrome = webdriver.ChromeOptions()
option_chrome.add_argument('headless')
option_chrome.add_argument("disable-gpu")

path = "/Users/laura/fippa-cleaning/chromedriver"

driver = webdriver.Chrome(executable_path=path, options=option_chrome)
driver.get(url)
```

