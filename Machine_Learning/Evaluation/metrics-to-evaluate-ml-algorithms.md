# Metrics to Evaluate ML Algorithms
Refer to [Metrics to Evaluate your Machine Learning Algorithm](https://towardsdatascience.com/metrics-to-evaluate-your-machine-learning-algorithm-f10ba6e38234). There's also extra content in this note.

## Types of Evaluation Metrics
- Classification Accuracy
- Logarithmic Loss
- Confusion Matrix
- Area under Curve
- F1 Score
- Mean Absolute Error
  - For more info check [Loss Functions - Notes](https://lauradang.gitbook.io/notes/machine-learning/loss-functions)
- Mean Squared Error
  - For more info check [Loss Functions - Notes](https://lauradang.gitbook.io/notes/machine-learning/loss-functions)

## Classification Accuracy
`Accuracy = # of correct predictions / Total  # of predictions`
- **Pros**: Good when equal samples/clas
- **Cons**: False sense of achieving high accuracy if unequal samples/class
- eg. If samples were 90% Class A and 10% Class B, Model could predict class A 100% of the time and it would have a 90% accuracy rate (which is clearly not correct)

## Logarithmic Loss
- Penalises *false* classifications
- **Pros**: Good with multiclass classification
- **Prior setup**:
  - Classifier must assign probability to each class for all samples
- **Equation parameters**:
  - *N*: Total # of samples
  - *M*: Total # of classes
  - *y_ij*: If sample *i* belongs to class *j* or not
  - *p_ij*: Probability of sample *i* belonging to class *j*
- **Range**: $$[0, \infty]$$
  - If logloss &rarr; 0, more accurate
  - If logloss → $$\infty$$, less accurate
![Logarithmic Loss](https://markhneedham.com/blog//uploads/2016/09/NEmt7.png) 

## Confusion Matrix
- **Output**: Matrix that describes entire performance of model
- **True Positives**: 
  - Predicted: YES 
  - Actual: YES
- **True Negatives**: 
  - Predicted: NO
  - Actual: NO
- **False Positives**: 
  - Predicted: YES
  - Actual: NO
- **False Negatives**: 
  - Predicted: NO
  - Actual: YES

`Accuracy of Matrix = (True Positives + False Negatives) / (Total # of Samples)`

## Area Under Curve (AUC)
- **Use Case**: Binary Classification
- **Output**:
  - AUC of TPR vs FPR Graph
  - Probability that classifier will rank positive example higher than negative example

![AUC](https://miro.medium.com/max/427/1*zFW1Kj3e2X_mmluTW3rVeA.png)

- **True Positive Rate (Sensitivity)**:
  - **Equation**: TP / (FN+TP)
  - **Range**: $$[0, 1]$$
  - **Meaning**: Positive data points with respect to ALL positive (actual) data points
- **False Positive Rate (Specificity)**:
  - **Equation**: FP / (FP+TN)
  - **Range**: $$[0, 1]$$
  - **Meaning**: Negative data points considered positive out of all negative (actual) data points

## F1 Score
- **Output**: Harmonic mean between precision and recall

![F1 Score](https://mk0caiblog1h3pefaf7c.kinstacdn.com/wp-content/uploads/2018/09/Capture-d%E2%80%99e%CC%81cran-2018-09-26-a%CC%80-16.42.24-e1538561198738.png)

- **Range**: $$[0, 1]$$
- **Meaning**:
  - Balance between Precision and Recall
  - Precision (how many instances it classifies correctly)
  - Robust (does not miss significant # of instances)
![Precision and Recall](https://miro.medium.com/max/888/1*7J08ekAwupLBegeUI8muHA.png)

