# Formatting table display

## Avoid the annoying `...`

```python
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)
```

## Print table to terminal

```python
print(df.head())
```

## Read CSV

```python
df.read_csv("file.csv")
```

## Export to CSV

```python
df.to_csv("file.csv")
```

## Print a summary of the data

```python
df.describe()
```

## Show Columns

```python
df.columns
```

## Drop all missing values

```python
df = df.dropna(axis=0)
```

## Get dimensions of table

```python
df.shape
>>(rows, columns)
```

## Get number of instances per class

```python
print(dataset.groupby('class').size())
```

## Univariate Plotting

```python
# Box and Whisker Plots
dataset.plot(kind='box', subplots=True, layout=(2,2), sharex=False, sharey=False)

# histograms
dataset.hist()

plt.show()
```

