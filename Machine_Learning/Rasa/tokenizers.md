# Tokenizers

### WhitespaceTokenizer
- Whitespace separated
- "today's" does not split

### MitieTokenizer
- Creates tokens for MITIE entity extractor

### SpacyTokenizer
- requires SpacyNLP
- supports splitting by quotations

### ConveRTTokenizer
- used when ConveRTFeaturizer is used
- [Code Implementation](https://github.com/RasaHQ/rasa/blob/3dccf2052a3400b25fe8108f8cd73dffbff9ef3e/rasa/nlu/tokenizers/convert_tokenizer.py#L85)