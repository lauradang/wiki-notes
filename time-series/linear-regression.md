# Linear Regression

* aka **Ordinary Least Squares \(OLS\)**
* minimizes sum of squared distances between data points and regression line

```python
import pandas as pd
pd.ols(y, x)

import statsmodel.api as sm
sm.OLS(y, x).fit()
# dependent vars = y
# independent vars + constants = x

import numpy as np
np.polyfit(x, y , deg=1)

from scipy import stats
stats.linregress(x, y)
```

**Add constant for linear regression intercept**

```python
import statsmodel.api as sm
df = sm.add_constant(df)
```

## Clean data

```python
df = df.dropna()
```

## Regression Output

* coef \(SPX\_Ret\) - slope of regression \(beta\)

```python
results.params\[1\]
```

* const: intercept of linear regression

```python
results.params\[0\]
```

* R-squared - sign = slope sign
* \[corr\(x,y\)\]^2 = R^2

