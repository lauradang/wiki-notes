# Random Forests

## Difficulties with trees

* More leaves lead to overfitting 
* Less leaves lead to inaccurate predictions \(cannot capture as many patterns and distinctions\) 

## What is a random forest?

* uses many trees 
* makes prediction by averaging the predictions of each component tree 
* better predictive accuracy than a single decision tree 

```python
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error

forest_model = RandomForestRegressor(random_state=1)
forest_model.fit(train_X, train_y)
melb_preds = forest_model.predict(val_X)
print(mean_absolute_error(val_y, melb_preds))
```

