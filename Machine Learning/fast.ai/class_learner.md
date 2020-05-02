# Training a Language and Classification Text Learner

```python
from fastai.text import *
from sklearn.model_selection import train_test_split
```

## Creating Databunches

We need to create databunches for both the language and classifcation model. 

```python
df = pd.read_csv(path/'train.csv', index_col=0)
train_df, valid_df = train_test_split(df, test_size=0.2)

data_lm = TextLMDataBunch.from_df(
    path,
    train_df=train_df,
    valid_df=valid_df,
    text_cols=[0, 2],
    bs=32
)

data_class = TextClasDataBunch.from_df(
    path,
    train_df=train_df,
    valid_df=valid_df,
    vocab=data_lm.train_ds.vocab,
    text_cols=[0, 2],
    label_cols=1,
    bs=32
)

data_class.show_batch() # sanity check
```

## Creating/Training the Language Learner

```python
lm_learn = language_model_learner(data_lm, AWD_LSTM, drop_mult=0.3)
lm_learn.fit_one_cycle(2, 1e-2)
lm_learn.unfreeze()
lm_learn.fit_one_cycle(5, 1e-3)

lm_learn.save_encoder(os.path.join(path, 'ft_enc')) # The classification learner uses this
```

## Creating/Training the Classification Learner

```python
# Creating
class_learn = text_classifier_learner(data_class, AWD_LSTM, drop_mult=0.3)
class_learn.load_encoder(os.path.join(path, 'ft_enc')) # The language model's encoder

# Finds the optimal learning rate automatically
class_learn.lr_find()
class_learn.recorder.plot(suggestion=True)
min_grad_lr = class_learn.recorder.min_grad_lr

# Training
class_learn.fit_one_cycle(5, min_grad_lr)
class_learn.freeze_to(-2)
class_learn.fit_one_cycle(1, slice(5e-3/2., 3e-2))
class_learn.unfreeze()
class_learn.fit_one_cycle(5, slice(2e-3/100, 3e-2))
```

## Predictions

```python
class_learn.predict("some text")
```

