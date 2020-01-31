# Requests and JSON

## Webscraping with XHR

1. Inspect page 
2. Navigate to Network &gt; XHR &gt; Name
3. Open in new tab or curl
4. Figure out pagination pattern from json link
5. Check if get or post \(Copy &gt; Copy Request Headers
6. Add parameters \(\)

   \`\`\`python

   import re

resp = requests.post\( "[https://data.fcm.ca/dynamics/projects](https://data.fcm.ca/dynamics/projects)", data={ "f": "gmfprojects", "p": "%", "p1": page\_num, "c": "en" } \)

resp = requests.get\( "[https://data.fcm.ca/dynamics/projects](https://data.fcm.ca/dynamics/projects)", params={ "f": "gmfprojects", "p": "%", "p1": page\_num, "c": "en" } \)

```text
### Extract JSON Data
```python
  for element in data[index]['name']['name']....:
  print(element)
```

