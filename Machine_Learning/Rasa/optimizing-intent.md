# Optimizing Intent

## Pretrained Embeddings: Intent Classifier Sklearn
#### What is it?
- Uses spacy
- Uses **word embeddings** (vector representations of words)
- Similar words get converted to similar numeric matrices
- Trains linear SVM - optimized with gridsearch (hyperparameter tuning to determine optimal values for model)
- Research paper: [word2vec](https://arxiv.org/abs/1301.3781)
- Depends on langauge (choose spacy's "en" for english)
  - Can customize word embeddings (look into [Facebook's fastText](https://github.com/facebookresearch/fastText/blob/master/docs/crawl-vectors.md#models))
  - Then link model ([spaCy guide](https://spacy.io/usage/vectors-similarity#converting))
```python
# Linking spaCy model with word embedding
python -m spacy link <converted model> <language code>
```
#### Pros and Cons
- Not much data needed
- Pretrained word embeddings
- Not available outside of English
- Does not cover domain specific words (product names, acrynoms)

## Supervised Embeddings: Intent Classifier TensorFlow Embedding
#### What is it?
**Pipeline name in Rasa**: [EmbeddingIntentClassifier](https://rasa.com/docs/rasa/nlu/components/#embeddingintentclassifier)
- trains word embeddings from scratch
- Typically used with [CountVectorsFeaturizer](https://rasa.com/docs/rasa/nlu/components/#countvectorsfeaturizer)
  - Counts how often distinct words in training data appear in message 
  - Then feeds this vector to intent classifier

- Another count vector created for intent label (for multiple intent support)

``` python
# Example:
Training data: ["best", "bot", "great", "is", "my", "the"]
"My bot is the best bot." = [1, 2, 0, 1, 1, 1]
"My bot is great." = [0, 1, 1, 1, 1, 0]
```
**Configuring CountVectorsFeaturizer (recommended featurizer for this classifier)**:
- change *analyzer* property to char (using ngram counts instead of word token counts)
  - More robust against typos
  
**Note**: Bag-of-words is unigram, n-grams lets you detect multiple words together (if its bigrams you can detect *United States*, not just *United*)

#### Pros and Cons
- Supports multiple intents per message
- Needs more training data (learning from scratch)
- Language independent

## Common Problems
#### Lack of Training Data
- Try [Chatito](https://rodrigopivi.github.io/Chatito/)
- Try Rasa Core Interactive

#### Out-of-Vocabulary Words
- Typos, words you did not think of
  - If using `EmbeddingIntentClassifier`:
    - More training data
    - Add examples that include `OOV_token` (out-of-vocab token)

#### Similar Intents
- Eg. You have 2 intents: `provide_name` and `provide_data`
- `provide_name`: It is Laura
- `provide_date`: It is on Monday
- These 2 are similar from NLU perspective - comine into one intent called `inform`

#### Skewed data
- Maintain equal # of examples per intent
















