# Evaluating Entities

## Case 1
- Dealing with entities of the same type

### Case 1a: # of predicted entities > # of actual entities
**Predicted**: `{name: [Laura, Will]}`
**Actual**: `{name: [Laura]}`

**Solution:**
```python
# This will be the score for that individual entity key (name)
intersection(predicted, actual) / set(predicted, actual)
```

### Case 1b: # of predictd entities < # of actual entities
**Predicted**: `{name: [Laura]}`
**Actual**: `{name: [Laura, Will]}`

**Solution**: *Same as Case 1a*

## Case 2
- Dealing with missing entity types

### Case 2a: # of predicted entity types > # of actual entity types
**Predicted**: 
```
{
  name: [Laura, Will]
  date: [today]
}
```
**Actual**:
```
{
  date: [today]
}
```

**Solution**:
- Give 0 to the extra entity (name)

### Case 2b: # of predicted entity types < # of actual entity types
**Predicted**: 
```
{
  date: [today]
}
```
**Actual**:
```
{
  name: [Laura, Will]
  date: [today]
}
```

**Solution**:
*Same solution as Case 2b*

## Overall Entity Score
In the end, we will have an average score for each type of entity (eg. name will have score 90%, date will have score 80%, etc.)

Take the average of all these scores and that will be the overall entity score.












