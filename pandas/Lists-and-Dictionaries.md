## Lists and Dictionaries 
#### List into Dataframe
```python
import pandas as pd
columns = ['A', 'B']
data = [
  ['1', '2'],
  ['3', '4'],
  ['5', '6']
]
df = pd.DataFrame(data, columns = columns)
```
#### Group lists into even numbers
```python
[l[i:i + n] for i in range(0, len(l), n)]
```

#### Dictionary into Dataframe
```python
import pandas as pd

columns = ['A', 'B', 'C']
project_name = ['1', '2']
company_name = ['3', '4']
contact_name = ['5', '6']

df = pd.DataFrame({
    "project" : project_name,
    "company" : company_name,
    "contact" : contact_name
})
```

#### Write list to txt (good for troubleshooting)
```python
with open('your_file.txt', 'w') as f:
    for item in my_list:
        f.write("%s\n" % item)
```