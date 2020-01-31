# Correlation-PCT\_CHANGE

## Correlation/PCT\_CHANGE

## Some Useful Pandas Tools

```python
# change index to datetime
df.index = pd.to_datetime(df.index)

# plotting data
df.plot(grid=True)

# join two dataframes
df1.join(df2)

# isolate dataset
df['col']

# Computing % changes and differences in time series
df['col'].pct_change()
df['col'].diff()

# pandas correlation method of Series
df['col_name'].corr(df['col_name2'])

# scatter plot
plt.scatter(df['col_name'], df['col_name2'])
plt.show()
```

**Correlation Coefficient**: measure of how much two series vary together

* correlation = 1: perfect linear relationship with no deviations

**Common Mistake:** Correlation of 2 Trending series:

* Correlation coefficient is not enough, must compare percentage differences too

