# Useful Commands

## Graphical Summaries

```R
data <- c(1, 2, 3, 4, 5, ...)
y <-  c(1, 2, 3, 4, 5, ...)

# Histogram
hist(data)

# Relative Frequency Histogram
hist(data, freq=FALSE)

# Empirical CDF
plot(ecdf(data))

# Boxplot
boxplot(data)

# Scatter
plot(data, y)
```

## Useful Parameters for Graphical Summaries

```R
freq=TRUE # boolean
main="title of plot"
xlab="x-axis label"
ylab="y-axis label"
lwd=3 # line thickness
col="colour-string" # colour of plotted data (e.g. "blue")
```

## Distributions

```R
# Chi-squared Distribution 
dchisq(x, k) # f(x;k)
pchisq(x, k) # F(x;k)

# Likelihood Ratio Test

# Example:
y<-c(70,75,63,59,81,92,75,100,63,58) # observed frequencies
e<-sum(y)/10 # expected frequencies
df<-9 # degrees of freedom = 10-1 = 9

# Likelihood Ratio Goodness of Fit Test
lambda<-2*sum(y*log(y/e))
pvalue<-1-pchisq(lambda,df)
c(lambda,pvalue)
> [1] 23.604947153 0.004971575

# Pearson goodness of fit statistic
d<-sum((y-e)^2/e)
pvalue<-1-pchisq(d,df)
c(d,pvalue)
> [1] 24.298913043 0.003852929
```

