# Language Processing Pipelines \(Spacy\)

When you call `nlp` on a text:

## Pipeline:

1. Spacy tokenizes text -&gt; produces `Doc` object and this object is passed through the next steps
2. Tagger
   * Assigns POS labels
3. Parser
   * Assigns dependency labels
4. ner
   * Detect and label named entities
5. Final Doc object has been processed

## Training

* Gather training data and evaluation data
  * ie. examples of text and labels \(could be POS, named entity, etc.\)
* Model is shown unlabelled text and makes a prediction \(statistical model\)
* Since we know the correct answer, can provide loss function

