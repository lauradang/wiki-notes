# Text Featurizers
- Transforms tokenized text into something machine can read
- 2 Categories: Sparse, Dense
  - Sparse: return feature vectors with a lot of missing values (eg. 0s)
  - Dense: Contains mostly non-zeroes

## MitieFeaturizer
- Requires: MitieNLP
- Dense featurizer
- only SklearnIntentClassifier can use this
- For pre-training your own word vectors (need a huge corpus initially)

## SpacyFeaturizer
- Requires: SpacyNLP

## ConveRT Featurizer
- Requires: ConveRTTokenizer
- Dense featurizer
- Short training time
- Do not fine-tune parameters
- Need intent AND RESPONSE features
  - eg. EmbeddingIntentClassifier
  - eg. ResponseSelector

## RegexFeaturizer
- No requirements
- Only supports CRFEntityExtractor

## CountVectorsFeaturizer
- No requirements
- Sparse featurizer
- bag-of-words representations (intent and response)
- To fine-tune: [sklearn.feature_extraction](https://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html)