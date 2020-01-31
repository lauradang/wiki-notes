# Foreign Key

## Show foreign key entries

```sql
SELECT * FROM table1 A 
INNER JOIN table2 B 
ON A.foreign_key_field = B.foreign_key_field
WHERE B.some_field = 1
```

