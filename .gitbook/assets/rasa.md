# Improving NLU Model

## Pipelines
2.`pretrained_embeddings_convert`
3.`pretrained_embeddings_spacy`

#### `supervised_embeddings`
- Uses whitespace for tokenization

Default Components:
```markdown
language: "en"

pipeline:
- name: "WhitespaceTokenizer"
- name: "RegexFeaturizer"
- name: "CRFEntityExtractor"
- name: "EntitySynonymMapper"
- name: "CountVectorsFeaturizer"
- name: "CountVectorsFeaturizer"
  analyzer: "char_wb"
  min_ngram: 1
  max_ngram: 4
- name: "EmbeddingIntentClassifier"
```
- eg. if chosen language is not whitespace-tokenized, replace ```WhitespaceTokenizer``` with your own tokenizer
- Note: uses 2 ```CountVectorsFeaturizer```
  - 1st one: featurizes text based on words
  - 2nd one: Featurizes based on character n-grams, preserving word boundaries

#### `pretrained_embeddings_convert`
- pretrained sentence encoding model [ConveRT](https://github.com/PolyAI-LDN/polyai-models) to extract vector representations of complete user utterance as a whole
```markdown
language: "en"

pipeline:
- name: "WhitespaceTokenizer"
- name: "ConveRTFeaturizer"
- name: "EmbeddingIntentClassifier"
```

#### `pretrained_embeddings_spacy`
- pre-trained word vectors from either **GloVe** or **fastText**
```markdown
language: "en"

pipeline:
- name: "SpacyNLP"
- name: "SpacyTokenizer"
- name: "SpacyFeaturizer"
- name: "RegexFeaturizer"
- name: "CRFEntityExtractor"
- name: "EntitySynonymMapper"
- name: "SklearnIntentClassifier"
```
[More about Spacy Models](https://rasa.com/docs/rasa/nlu/language-support/#pretrained-word-vectors)

#### `MITIE`
- Need your own word corpus
[Learn more to train](https://rasa.com/docs/rasa/nlu/language-support/#mitie)
```markdown
language: "en"

pipeline:
- name: "MitieNLP"
  model: "data/total_word_feature_extractor.dat"
- name: "MitieTokenizer"
- name: "MitieEntityExtractor"
- name: "EntitySynonymMapper"
- name: "RegexFeaturizer"
- name: "MitieFeaturizer"
- name: "SklearnIntentClassifier"
```















