# Measuring model accuracy

A. predictor.score\(X,Y\) internally calculates Y'=predictor.predict\(X\) and then compares Y' against Y to give an accuracy measure. This applies not only to logistic regression but to any other model.

B. logreg.score\(X\_train,Y\_train\) is measuring the accuracy of the model against the training data. \(How well the model explains the data it was trained with\). &lt;-- But note that this has nothing to do with test data.

C. logreg.score\(X\_test, Y\_test\) is equivalent to your print\(classification\_report\(Y\_test, Y\_pred\)\). But you do not need to calculate Y\_pred; that is done internally by the library

