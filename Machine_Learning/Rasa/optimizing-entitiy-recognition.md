# Optimizing Entitiy Recognition

### SpaCy ([SpacyEntityExtractor](https://rasa.com/docs/rasa/nlu/components/#spacyentityextractor)) - `ner_spacy`
- Pretrained entity extractors
- Statistical BILOU transition model

### Duckling
- Number related information (dates, distance, duration)
- Run server on docker image [ner_duckling](http://rasa.com/docs/rasa/nlu/components/#ducklinghttpextractor)

### NER_CRF ([CRFEntityExtractor](https://rasa.com/docs/rasa/nlu/components/#crfentityextractor))
- trained from scratch
- Need to annotate training data yourself
- Annotate training examples EVERYWHERE in training data (even if entity is not relevant for intent)
- Use of lookup tables makes `ner_crf` prone to overfitting
  - If training data matches Regex or Lookup, it will ignore other features, so if you have message with entity that is not matched by Regex, `ner_crf` will not detect

## Common Problems
### Entities are not recognizing unseen values
- Could be:
  - Lack of training data
  - Overfitting of `ner_crf` (try training model without regex or look up)

### Map extracted entity to different value
- [ner_synonyms](http://rasa.com/docs/rasa/nlu/components/#entitysynonymmapper)