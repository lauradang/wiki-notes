# Loss Functions
**Review**: Loss functions evaluate how well the model performs (how much the predicted result deviates from actual result)

## Regression Loss Functions
- Predicts continuous value (eg. floor size, # of rooms)

### Mean Square Error / Quadratic Loss / L2 Loss
![MSE](https://miro.medium.com/max/342/1*SGhoeJ_BgcfqU06CmX41rw.png)
- Measures magnitude without considering direction
- Squaring penalizes further deviated values much more than less deviated values

### Mean Absolute Error / L1 Loss
![MAE](https://miro.medium.com/max/355/1*piCo0iDgPmESnQkHSwAK6A.png)
- More robust to outliers (no squaring)
- Needs linear programming to calculate gradients

### Mean Bias Error
![MBE](https://miro.medium.com/max/331/1*BpYT_vpYizQpeY3bGuvTbw.png)
- Same as MAE but no absolute
  - This is kinda bad as it makes things less accurate
- Used for seeing positive or negative bias

## Classification Loss Functions
- Predict output from finite set of categorical values (e.g. 0-9)

### Hinge Loss / Multiclass SVM Loss
![Hinge Loss](https://miro.medium.com/max/539/1*ekz6PLfuwA0I_w-xmMqBqg.png)
- Score of correct category should be greater than sum of scores of all incorrect categories by some safety margin (usually one)
- Usually for SVM

### Cross Entropy Loss / Negative Log Likelihood
![Cross Entropy Loss](https://miro.medium.com/max/795/1*zi1wKAAGGt1Bn6mqo2MSFw.png)
- Most common
- Loss increases as predicted probability diverges from actual label
- Penalizes heavily predictions that are confident but WRONG
