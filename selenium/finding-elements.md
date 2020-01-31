# Finding Elements

## XPaths

1. Inspect Element
2. Copy XPath
3. You get: `//*[@id="id"]/tag/anothertag`
4. Remove star and find last tag and insert it at the front of XPath:

   ```python
   driver.find_element_by_xpath("//tag[@id="id"]/tag/anothertag")
   ```

   **Clicking**

   ```python
   option = driver.find_element...
   option.click()
   ```

## Get all links on page

```python
elems = driver.find_elements_by_xpath("//a[@href]")
for elem in elems:
    print elem.get_attribute("href")
```

