# Selecting Data for Modeling

## Two Approaches

* Dot notation
  * Select the "prediction target"
* Selecting with a column list
  * Selects the "features"

## Dot Notation \(choosing pred. target\)

* Select column we want to predict \(Prediction Target\)

```python
# By convention, this is named y
y = model.Column
```

## Choosing "features"

* Features are columns inputted into model

  ```python
  features = [price, name, clothes]
  # By convention, this is named X
  X = model[features]
  ```

## Steps to building and using a model

* Define
  * What type of model? \(eg. decision tree\)
* Fit
  * Capture patterns from model
* Predict
* Evaluate
  * Determine accuracy of model's predictions

## Example using scikit-learn

If you do not specify random\_state number, model may allow for some randomness in model training

```python
from sklearn.tree import DecisionTreeRegressor

# Define model. Specify a number for random_state to ensure same results each run
model = DecisionTreeRegressor(random_state=1)

# Fit model
model.fit(X, y)

>>DecisionTreeRegressor(criterion='mse', max_depth=None, max_features=None,
           max_leaf_nodes=None, min_impurity_decrease=0.0,
           min_impurity_split=None, min_samples_leaf=1,
           min_samples_split=2, min_weight_fraction_leaf=0.0,
           presort=False, random_state=1, splitter='best')
```

```python
print("Making predictions for the following 5 houses:")
print(X.head())
print("The predictions are")
print(melbourne_model.predict(X.head()))

>>> Making predictions for the following 5 houses:
   Rooms  Bathroom  Landsize  Lattitude  Longtitude
1      2       1.0     156.0   -37.8079    144.9934
2      3       2.0     134.0   -37.8093    144.9944
4      4       1.0     120.0   -37.8072    144.9941
6      3       2.0     245.0   -37.8024    144.9993
7      2       1.0     256.0   -37.8060    144.9954
The predictions are
[1035000. 1465000. 1600000. 1876000. 1636000.]
```

