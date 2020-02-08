# Gibberish n-gram Language Model

**Example**:
```python
from nltk.corpus import brown
from nltk import word_tokenize
from collections import Counter
import numpy as np

train_text = '\n'.join([' '.join([word for word in sentence]) for sentence in brown.sents()])

token = nltk.word_tokenize(train_text)
unigrams = ngrams(token, 1)
bigrams = ngrams(token, 2)
trigrams = ngrams(token, 3)

weights = [0.001, 0.01, 0.989]

def strangeness(text):
    r = 0
    text = '  ' + text + '\n'
    for i in range(2, len(text)):
        char = text[i]
        context1 = text[(i-1):i]
        context2 = text[(i-2):i]
        num = unigrams[char] * weights[0] + bigrams[context1+char] * weights[1] + trigrams[context2+char] * weights[2] 
        den = sum(unigrams.values()) * weights[0] + unigrams[char] + weights[1] + bigrams[context1] * weights[2]
        r -= np.log(num / den)
    return r / (len(text) - 2)
```

## Walkthrough
### Brown Corpus
- Million-word corpus of English 
- 500 sources
- news, editorials

### Creating unigrams
- Uses 










