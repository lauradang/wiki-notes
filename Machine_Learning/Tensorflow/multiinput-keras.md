# Multi-input Keras Model

## Creating the Labels

```python
from sklearn import preprocessing
from keras.utils import to_categorical

label_encoder = preprocessing.LabelEncoder()

# the y that is being passed in is a pandas series of categorical data
y = label_encoder.fit_transform(y) 

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1)

y_train = to_categorical(y_train)
y_test = to_categorical(y_test)

# prints the classes of y 
print(label_encoder.classes_)
```

## Preparing Text Input

**Minimizing noise**

- To minimize noise in our text, we process the text by removing puncutations, numbers, and excessive spacing.

**Convert text into suitable input format for model**

- Our model only understands numeric values, so we have to convert our textual input into vectors
- We use pretrained word embeddings to create these vectors.

### Creating vectors for each word provided by gloVe

```python
from tqdm.notebook import tqdm

embeddings_dict = {}

# Download glove.6B.300d.txt from the gloVe website
with open(f"{ROOT}/glove.6B.300d.txt", "r", encoding="utf8") as glove_file:
  for line in tqdm(glove_file):
    records = line.split()
    word = records[0]
    vector_dim = np.asarray(records[1:], dtype="float32")
    embeddings_dict[word] = vector_dim
```

### Converting text to sequences

```python
def convert_text_to_numeric(text_input):
  maxlen = 200
  tokenizer = Tokenizer(num_words=5000)
  tokenizer.fit_on_texts(text_input)

  sequences = tokenizer.texts_to_sequences(text_input)
  vocab_size = len(tokenizer.word_index) + 1
  sequences = pad_sequences(sequences, padding="post", maxlen=maxlen)

  return {
      "numeric": sequences, 
      "vocab_size": vocab_size,
      "tokenizer": tokenizer
  }

X_train = list(X_train["column"])
channel_name_train = convert_text_to_numeric(channel_name_train)
```

### Creating word embeddings

```python
def create_word_embeddings(vocab_size, tokenizer):
  embedding_matrix = np.zeros((vocab_size, 300))

  for word, index in tokenizer.word_index.items():
      embedding_vector = embeddings_dict.get(word)
      if embedding_vector is not None:
          embedding_matrix[index] = embedding_vector
  
  return embedding_matrix

X_train_embedding = create_word_embeddings(
    channel_name_train["vocab_size"],
    channel_name_train["tokenizer"]
)
```

## Preparing meta data

We don't need to do much to this data since it is already numerical data.

```python
X_train1 = X_train[["column1"]].values
```

## Building the Model

```python
def create_model():
  input_1 = Input(shape=(maxlen,))
  input_2 = Input(shape=(1, ))

  # Submodel #1
  embedding_layer1 = Embedding(
      X_train["vocab_size"], 
      X_train_embedding.shape[1],
      weights=[X_train_embedding],
      trainable=False # Keras embedding layers are pretrained
  )(input_1)
  lstm_layer_1 = LSTM(32)(embedding_layer1)
  
  # Submodel #2
  dense_layer_1 = Dense(10, activation="relu")(input_2)
  dense_layer_2 = Dense(10, activation="relu")(dense_layer_1)

  # Concat submodel outputs together to produce input for the overall model
  concat_layer = Concatenate()([lstm_layer_1, dense_layer_2])

  # Overall model
  dense_layer_3 = Dense(10, activation="relu")(concat_layer)
  
  num_of_classes = 2
  output = Dense(num_of_classes, activation="softmax")(dense_layer_3)
  model = Model(inputs=[input_1, input_2], outputs=output)

  return model
```

## Training the Model

```python
history = model.fit(
    x=[X_train["numeric"], X_train1], 
    y=y_train, 
    batch_size=32, 
    epochs=7, 
    verbose=1, 
    validation_split=0.2
)
```

























