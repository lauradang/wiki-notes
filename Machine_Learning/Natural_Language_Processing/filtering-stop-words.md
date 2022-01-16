# Filtering Stop Words
```python
re.sub(r'(?<!\S)(?:{})(?!\S)'.format("|".join(map(re.escape, stop_words))), '', whole_corpus) 
```