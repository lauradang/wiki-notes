# Loading Data

### Initial Questions
 - What is the distribution of all the categories in this data?
   - The .wave files are different lengths, so we can't just get the mean of number of wav files per label.
   - **Solution**: Create a `matplotlib.pyplot` with length!

## Analyze distribution of categories in data using Pyplot
**Prerequisite Knowledge**:
- `wavefile.read("file.wav")` → `(sample rate (int), data (numpy array)`
  - Used this instead of `librose.load()` in this case because:
    - Faster in most cases
    - By default, wavefile does not normalize the data (get an accurate sample rate with no manipulation to the data)
  $$SampleRate = \frac{samples}{sec}$$
  - `data.shape = (num_samples, num_channels)`
  - Therefore, `length = data.shape[0] / sample_rate` 
- `np.array.shape` → `(width, height)`
```python
df = pd.read_csv('instruments.csv')
df.set_index('fname', inplace=True)

for fname in df.index:
    rate, signal = wavfile.read(f'wavfiles/{fname}')
    df.at[fname, 'length'] = signal.shape[0] / rate

classes = list(np.unique(df.label))

# Get mean of length for each label
class_dist = df.groupby(['label'])['length'].mean()

# Returns figure object and axis which we customize
fig, ax = plt.subplots()
ax.set_title('Class Distribution', y=1.08)
ax.pie(class_dist, labels=class_dist.index, autopct='%1.1f%%',
       shadow=False, startangle=90)
ax.axis('equal')
plt.show()
```


