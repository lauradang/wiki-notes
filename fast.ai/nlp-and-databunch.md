# NLP and DataBunch
  
1. Prepare raw data (.txt, .csv, dataframe, tokens, labels arrays, ids, etc.)
2. Assemble raw data in a `DataBunch`(prepares data for NLP)

**Different classes that create a `DataBunch`**:
| class             | function              |
|-------------------|-----------------------|
| TextLMDataBunch   | Trains language model |
| TextClasDataBunch | Trains RNN classifier |

3. Create a `Learner` with a language model using the `DataNumch`