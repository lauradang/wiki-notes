# Key-Word Finder

## High-Level Approach

1. Text pre-processing
   * noise removal
   * normalisation
2. Data Exploration
   * Word cloud to understand frequently used words
   * Top 20 single words, bi-grams, tri-grams
3. Convert text to vector of word counts
4. Convert text to vector of term frequencies
5. Sort terms in descending order based on term frequencies to identify top N keywords

## Normalization

Handling multiple ocurrences of the same word eg. Learning, learn, learned, learner will just be "learn" 1. Stemming

* Removes suffices
  1. Lemmatization
* works based on root of word \(more advanced\)

## Removing stopwords

* Stop words include large \# of prepositions, pronouns, conjunctions, etc. in sentences. \(these must be removed\)
* default list in python nltk library
* May want to add more

## Convert wordcloud to ML-friendly format

Has two parts:

1. Tokenisation
   * converting cts text into list of words
2. Vectorisation
   * list of words converted to matrix of    integers
3. We use bag of words model

   \`\`\`python

   from sklearn.feature\_extraction.text import CountVectorizer

cv=CountVectorizer\(max\_df=0.8,stop\_words=stop\_words, max\_features=10000, ngram\_range=\(1,3\)\) X=cv.fit\_transform\(corpus\)

\`\`\`

* max\_df: ignores terms that have a document frequency higher than given threshold \(corpus-specific stop words\) - ensures we have not commonly used words 
* max\_features: determines number of columns in matrix
* n-gram range: would want to look at single words, two words \(bi-grams\), three words \(tri-grams\)
* returns an encoded vector with a length of entire vocabulary

## Converting to matrix of integers

* Using TF-IDF vectoriser
* Downfalls of just using mere word count from countVectoriser:
  * large counts of certain common words may dilute impact of more context specific words in corpus
  * TF-IDF overcomes this - penalizes words that appear several times across document
* Scores words based on context, not frequency

  2 components to TF-IDF:

* TF: Term Frequency \(Frequency of term / Total \# of terms\)
* IDF: Inverse Document Frequency \(log\(Total documents\) / \# of documents with term\)

