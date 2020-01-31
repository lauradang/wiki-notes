# Postgres

## Postgres

Download Postgres: [PostgreSQL: Downloads](https://www.postgresql.org/download/)

### Set up database credentials

```bash
postgres=# \password new_name
postgres=# CREATE DATABASE db_name;
```

### Connection

```python
from psycopg2 import sql

conn = psycopg2.connect(
    user = "new_name",
    password="password",
    host="127.0.0.1",
    port="port_number",
    database="db_name"
)
cursor = conn.cursor()
```

### Commit Changes

```python
conn.commit()
```

### Create Table

```python
table = (
        """
        CREATE TABLE IF NOT EXISTS
        table (
            id SERIAL PRIMARY KEY,
            name TEXT,
            date DATE,
            status BOOLEAN,
            num INTEGER,
            UNIQUE (num)
        );
        """
)
cursor.execute(table)
```

### Insert

```python
insert = """
    INSERT INTO 
    table (name, date)
    VALUES (%s, %s)
"""
cursor.execute(insert, ("Hello", "2014-09-03"))
```

### Update

```python
update = """
    UPDATE table 
    SET name = %s,
        date = %s
    WHERE num = %s
"""
cursor.execute(update, ("Hi", "2019-03-20"))
```

### Select

```python
cursor.execute("""
    SELECT num FROM table 
    WHERE num = %s;
""", (2, ))
```

### Get value in row

```python
cursor.fetchone()[column_num]
```

### Rollbacks

```python
cursor.execute('SAVEPOINT sp2')

try:
  cursor.execute("""
    SELECT num FROM table 
    WHERE num = %s;
  """, (2, ))
except psycopg2.IntegrityError:
  cursor.execute('ROLLBACK TO SAVEPOINT sp2')
```

## Convert Postgres Database to CSV

```sql
COPY table_name/query TO '/Users/laura/...path_to/file.csv' DELIMITER ',' CSV HEADER;
```

