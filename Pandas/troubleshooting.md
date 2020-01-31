# Troubleshooting
### Unicode Error
Try:
```python
df = pd.read_csv("fdd-report.csv", encoding = "ISO-8859-1")
```