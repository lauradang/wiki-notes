# Model Preparation
We need to create an arbitary amount of time to sample the data with (We will be using 1/10 second, you're model should be able to predict within this timeframe). Try not to go above 1 second.

## Calculate Number of Sample Chunks
- Decided to chunk audio files into secions that are 1/10 seconds long
- Want to calculate how many chunks in total 
Note: We multiply by 2 so we can get a larger sample size to ensure we have enough data.
```python
sample_size = 2 * int(df.length.sum() / 0.10)
```
