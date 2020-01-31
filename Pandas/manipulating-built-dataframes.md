## Manipulating built dataframes 
#### Apply function
```python
df['column_name'] = df['column_name'].apply(
lambda x : 
  float(x.replace("$", "0",).replace(",", "").strip()))
```
#### Insert column
```python
df.insert(1, 'column_name', data)
```

#### Resetting index
```python
df = df.reset_index(drop=True)
pd.concat([s1, s2], ignore_index=True)
```

#### Remove rows that do not contain numbers
```python
df[pd.to_numeric(df['Funding'], errors='coerce').notnull()]
```

#### Drop if all columns are Nan
```python
df.dropna(axis=0, how='all')
```
#### Clean up all cells in dataframe
```python
def clean(row):
    return row.replace("nan", "").strip()

df.applymap(clean)
```

#### Drop rows with NAs in specific columns
```python
df = df.dropna(axis=0, subset=['column_name'])

# Replace values with NA to make this wok
import numpy as np

df['column_name'] = df['column_name'].replace('-', np.nan)
df = df.dropna(axis=0, subset=['column_name'])
```

#### Drop rows with specific strings
```python
df[~df.C.str.contains("XYZ", na=False)]
```

#### Drop rows with empty cells
```python
df['Tenant'].replace('', np.nan, inplace=True)
```












