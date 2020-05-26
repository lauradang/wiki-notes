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
```

