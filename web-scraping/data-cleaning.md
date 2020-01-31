# Data Cleaning

## Datetime

```python
from datetime import datetime, date

date = "2014-03-02"
datetime.strptime(date, '%Y-%m-%d')
>> 2014-03-02 00:00:00
datetime.strptime(date, '%Y-%m-%d').date()
>> 2014-03-02

date = "Jun 1 2005 12:00PM"
datetime.strptime(date, '%b %d %Y %I:%M%p').date
>> 2005-06-01 12:00:00

date = "June 1 2005 12:00PM"
datetime.strptime(date, '%B %d %Y %I:%M%p').date
>> 2005-06-01 12:00:00

date = "Jun 1 2005 1:00"
datetime.strptime(date, '%b %d %Y %I:%M').date
>> 2005-06-01 01:00:00


%b %d %Y %I:%M%p'
```

## Clean Column Names

```python
df.columns.str.strip().str.lower().str.replace(' ', '_').str.replace('(', '').str.replace(')', '')
```

## Slugify

```python
from slugify import slugify, Slugify, UniqueSlugify

custom_slugify = Slugify(to_lower=True)
custom_slugify.separator = '_'

new = [custom_slugify(col) for col in df.columns]

df.columns = new
```

