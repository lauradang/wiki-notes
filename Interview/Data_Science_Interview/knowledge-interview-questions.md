# Knowledge Interview Questions

### What is Data Science?
- discovering hidden patterns from raw data
- software engineers use these tools to build platforms for user
- we use these programming tools to analyze and draw conclusions on datasets


### Supervised vs. Unsupervised Learning
**Supervised**:
- input data is labeled
- uses training dataset
- used for prediction
- enables classification and regression
- Algorithms:
  - decision tree
  - logistic regression
  - support vector machine

**Unsupervised:**
- input data is unlabeled
- uses input data set
- used for analysis
- grouping things together that look like they should be together
- enables Classification, Density, Estimation, Dimension Reduction
- Algorithms:
  - k-means
  - clustering
  - hierarchal clustering
  - apriori algorithm

### Logistic Regression
- predicts binary outcome (2 outcomes) from linear combination of predictor variables
- Linear graph to a sigmoid function:
  - Beginning is at 0, end is at 1

### Recommender Systems
- Information filtering system that predicts preferences
1. Collaborative Filtering
  - recommend tracks played by other users with similar interests
2. Content-based Filtering
  - uses properties of song to recommend music with similar properties

### Descriptive Statistical Analysis Techniques
- Univariate
  - describe data
  - you can evaluate mean, mode, range
- Bivariate - eg. scatterplot
  - show relationship between
  - positive correlation, negative 
- Multivariate

### Normal Distribution
- Bell shaped curve
- symmetrical
- no bias on left or right

### Linear Regression
- X - predictor variable (independent)
- Y - criterion variable (dependent)
##### Finding RMSE and MSE (measures of accuracy for linear regression)
- RMSE (Root Mean Square Error)
  - (sqrt(sum of (predicted-actual)^2)/N
- MSE (Mean Square Error / Average Square)
  - (1/N)(sum of (predicted-actual)^2)
N = Total number

### Interpolation
- Estimating value from 2 known values in a list of values


### Extrapolation
- approximating value by extending known data

### Decision Tree
1. Take entire dataset as input
2. Calculate entropy of target variables and predictor attributes
- the more different the objects in dataset, the more chaotic - higher entropy
4. Calculate information gain of all attributes
- gain info from sorting different objects from the entropy
5. Choose attribute with highest info gain as root node
- whichever split lowers the chaos the mot, this is the root n
- Repeat until each decision node is finalized

### Random Forest Model
1. Randomly select k features from m features (k < m)
- many little decision trees

### Overfitting
- when model is overtrained, memorizes training set
- can tell if training accuracy is high but test accuracy is low

##### Avoid Overfitting
1. Reduce variables - reduce noise
2. Use cross-validation techniques
  - eg. k-folds, cross-validation
3. Use regularization techniques such as LASSO to penalize certain model parameters if they're likely to cause overfitting

### Feature Selection
1. Filter Methods
  - Linear Discriminant Analysis
  - ANOVA
  - Chi-Square
2. Wrapper Methods
  - Forward Selection
  - Backward selection
  - Recursive feature  elimination

### Dealing with missing data values:
1. If data set is huge
  - remove rows with missing values
2. If not
  - Substitute missing values with mean of dataset (using pandas)

### Dimensonality Reduction
- Convert set of data with vast dimensions into less dimensions
  - reduces storage space
  - reduces computation time
  - removes redundant features (no point storing m and inches)

### Maintaining Deployed Model
1. Monitor
  - needed to determine performance accuracy of models
2. Evaluate
  - evaluation metrics of current model calculated to determine if new algorithm is needed
3. Compare
  - new models compared against each other, see which performs the best
4. Rebuild
  - rebuild model

### K-Means
- K = # of different groups selected
Algorithm:
1. Clusers data into k groups
2. Select k points at random as cluster centers
3. Assign objects to their closest center according to Euclidean distance
4. Calculate mean of all objects in each cluster
5. Repeat steps 2, 3, 4 until same points are assigned to each cluser

##### Selecting k for k-means
**Elbow Method:**
- Graph cost function against K
- Wherever there is a dip, is the elbow, and that is your k value (you want to minimize your loss function)
- Starts to flatten after k value, no point in taking the ones after

### P-Value
- Null hypothesis
  - No variation between variables
  - For one variable - it is just the mean
- <0.05
  - strong evidence against null hypothesis
- >0.05
  - Weak evidence against null hypothesis
  - your hypothesis is probably wrong
    - since null hypothesis seems correct, that means there's no variation between variables
- 0.05
  - marginal (could go either way)

### Outliers
**Drop**:
1. Drop only if it is garbage value
  - if you are measuring height, and the height is a string, you can remove this
2. If they have extreme values, they can be removed


**If you can't drop**:
- try different model (if it looks like curve rather than line, don't use linear model)
- try normalizing data (extreme data points pulled to similar range)
- use algorithms less affected by outliers (eg. random forest)


### Stationary Time series data
- When variance and mean of series is constant with time

### Confusion Matrix:
- describes performance of classification model
- actual vs. predicted

### Calculating Accuracies using confusing matrix
Accuracy = (True Positive + True Negative) / Total Observations

    | Total=650 | Actual | Actual | Actual |
    |-----------|--------|--------|--------|
    | Predicted |        | p      | n      |
    | Predicted | p      | 262    | 15     |
    | Predicted | n      | 26     | 347    |


- P and P = True positive
- N and N = True Negative
- Actual P and Predicted N = False Negative
- Actual N and Predicted P = False Positive

### Precision and Recall Rate
    | Total=650 | Actual | Actual | Actual |
    |-----------|--------|--------|--------|
    | Predicted |        | p      | n      |
    | Predicted | p      | 262    | 15     |
    | Predicted | n      | 26     | 347    |
Precision = (True Positive) / (True Positive + False Positive)

Recall Rate = (True Positive) / Total Positive + False Negative)

### Machine Learning Algorithms Used for Inputing Missing Values of both Categorical and Continuous Variables
- K-NN

### Calculate Entropy 
p = # of target (usually 1)
n = # of non-target (usually 0)
Entropy = 
-(p/(p+n))*log2(p/(p+n)) - (n/(p+n))*log2(n/(p+n))

### Choose algorithms based on case
**Question:** Probability of death from heart disease based on 3 risk factors: age, gender, blood cholesterol

**Answer:** Logistic Regression

**Question:** After studying behaviour of population, you have identified 4 specific individual types who are valuble to your study. You would like to find all users who are most similar to each individual type. Which algorithm?

**Answer:** 
- K-means clustering (grouping people together - 4 is the k value)

### Choose analysis method based on case
**Question:** Your organization has website where visitors randomly receive 1/2 coupons. It is also possible that visitors to the website will not receive a coupon. You have been asked to determine if offering a coupon to visitors to your website has any impact on their purchase decision. Which analysis method should you use?

**Answer:** One-Way ANOVA

### Association Rules Algorithm















