# Autocorrelation/Serial Correlation
- Correlation of time-series with a lagged copy of itself
- same series, but lagged by a day (lag-one correlation)


**Mean Reversion**
- negative autocorrelation

**Momentum/Trend Following**
- positive autocorrelation

**Computing autocorrelations:**
```python
# Convert index to datetime
df.index= pd.to_datetime(df.index)

# Downsample from daily to monthly data
df = df.resample(rule="M", how="last")
# rule: frequency (M is monthly)
# how: how to do resampling (first, last, average date of period)

df['Return'] = df['Price'].pct_change()
autocorrelation = df['Return'].autocorr()
```