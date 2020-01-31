# Model Validation
##### Prediction error: ```error = actual - predicted ```
##### Mean Absolute Error (MAE): ```Average of | error | ```

```python
from sklearn.metrics import mean_absolute_error

predicted_prices = model.predict(X)
mean_absolute_error(y, predicted_prices)
```

##### Validation Data
- when new data is introduced to model, the model's predictions will not be accurate
- since model's practical value comes from predicting new data, we measure performance on new data that was not used in model
- therefore, when building model, you exclude some data and use it as test data
- test data = validation data

```python
from sklearn.model_selection import train_test_split

# split data into training and validation data, for both features and target
# The split is based on a random number generator. Supplying a numeric value to
# the random_state argument guarantees we get the same split every time we
# run this script.
train_X, val_X, train_y, val_y = train_test_split(X, y, random_state = 0)
# Define model
melbourne_model = DecisionTreeRegressor()
# Fit model
melbourne_model.fit(train_X, train_y)

# get predicted prices on validation data
val_predictions = melbourne_model.predict(val_X)
print(mean_absolute_error(val_y, val_predictions))
````


## Splitting
groups = 2^(# of splits)

##### Overfitting
- model matches training data almost perfectly
- model does poorly in validating new data

##### Underfitting
- fails to capture patterns in data - does poorly even in training data

##### Optimizing model
- Try to get the spot between the underfitting curve and the overfitting curve
- ```max_leaf_nodes``` controls this
- more leaves = model moving closer to overfitting than underfitting

```python
from sklearn.metrics import mean_absolute_error
from sklearn.tree import DecisionTreeRegressor

def get_mae(max_leaf_nodes, train_X, val_X, train_y, val_y):
    model = DecisionTreeRegressor(max_leaf_nodes=max_leaf_nodes, random_state=0)
    model.fit(train_X, train_y)
    preds_val = model.predict(val_X)
    mae = mean_absolute_error(val_y, preds_val)
    return(mae)
```
- Can use for loop to see what number of max_left_nodes is optimal
```python
# compare MAE with differing values of max_leaf_nodes
for max_leaf_nodes in [5, 50, 500, 5000]:
    my_mae = get_mae(max_leaf_nodes, train_X, val_X, train_y, val_y)
    print("Max leaf nodes: %d  \t\t Mean Absolute Error:  %d" %(max_leaf_nodes, my_mae))
 >>Max leaf nodes: 5         Mean Absolute Error:  347380
Max leaf nodes: 50           Mean Absolute Error:  258171
Max leaf nodes: 500          Mean Absolute Error:  243495
Max leaf nodes: 5000         Mean Absolute Error:  254983
```
From the example, 500 max leaf nodes is optimal