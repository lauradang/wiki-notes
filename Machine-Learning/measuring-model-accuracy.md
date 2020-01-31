# Measuring model accuracy


A. predictor.score(X,Y) internally calculates Y'=predictor.predict(X) and then compares Y' against Y to give an accuracy measure. This applies not only to logistic regression but to any other model.

B. logreg.score(X_train,Y_train) is measuring the accuracy of the model against the training data. (How well the model explains the data it was trained with). <-- But note that this has nothing to do with test data.

C. logreg.score(X_test, Y_test) is equivalent to your print(classification_report(Y_test, Y_pred)). But you do not need to calculate Y_pred; that is done internally by the library