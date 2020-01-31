# Read PDFs

## Extracting text

```python
import PyPDF2

pdfFile = open('file.pdf', 'rb')
pdfReader = PyPDF2.PdfFileReader(pdfFile)
pageObj = pdfReader.getPage(i)
page = pageObj.extractText()
```

## Number of pages

```python
page_num = pdfReader.getNumPages()
```

