# PDF to CSV

## Tabula

```python
import tabula
df = tabula.read_pdf("file.pdf")
tabula.convert_into(pdf, "output.csv", output_format="csv")
```

## Dealing with multi-line tables

```python
tabula.read_pdf("BC Civil Forefeiture 2014-15 Grant Recipients.pdf",spreadsheet=True, pages='all')
```

