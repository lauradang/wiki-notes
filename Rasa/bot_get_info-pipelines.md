# `bot_get_info` Pipelines

## Focusing on Intent
```markdown

# custom1.yml
pipeline:
    - name: "SpacyNLP"
    - name: "SpacyTokenizer"
    - name: "SpacyFeaturizer"
    - name: "SpacyEntityExtractor"
      dimensions: ["DATE"]
    - name: "CRFEntityExtractor"
    - name: "SklearnIntentClassifier"

# custom2.yml
pipeline:
    - name: "SpacyNLP"
    - name: "SpacyTokenizer"
    - name: "SpacyFeaturizer"
    - name: "SpacyEntityExtractor"
      dimensions: ["DATE"]
    - name: "CRFEntityExtractor"
    - name: "EmbeddingIntentClassifier"

# custom3.yml
pipeline:
    - name: "SpacyNLP"
    - name: "ConveRTTokenizer"
    - name: "ConveRTFeaturizer"
    - name: "SpacyEntityExtractor"
      dimensions: ["DATE"]
    - name: "CRFEntityExtractor"
    - name: "SklearnIntentClassifier"

# custom4.yml
pipeline:
    - name: "SpacyNLP"
    - name: "ConveRTTokenizer"
    - name: "ConveRTFeaturizer"
    - name: "SpacyEntityExtractor"
      dimensions: ["DATE"]
    - name: "CRFEntityExtractor"
    - name: "EmbeddingIntentClassifier"
```
