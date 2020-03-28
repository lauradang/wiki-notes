# Data Preparation
We need to create an arbitary amount of time to sample the data with (We will be using 1/10 second, you're model should be able to predict within this timeframe). Try not to go above 1 second.

## Calculate Number of Sample Chunks
- Decided to chunk audio files into secions that are 1/10 seconds long
- Want to calculate how many chunks in total 
Note: We multiply by 2 so we can get a larger sample size to ensure we have enough data.
```python
sample_size = 2 * int(df.length.sum() / 0.10)
```

## Calculate Probability Distribution of Categories

- For randomly selecting categories when going through samples

```python
categories = list(np.unique(df.label))
categories_dist = df.groupby(["label"])["length"].mean()

# Normalizing means
prob_dist = categories_dist / categories_dist.sum()

# What we want to use the probability distribution for
# random.choice needs percentages for probability distribution (which is why we normalized)
rand_category = np.random.choice(categories, p=prob_dist)
```

## Building Model Config Class

- To easily manipulate model (e.g. change the type of network we are building (This project supports convolutional and reccurent))

```python
SAMPLE_SECTION_VALUE = <int that represents the length we are going to chunk the data>

class ModelConfig:
  	# The optional parameters are set to conventional values
    def __init__(self, mode="conv", nfilt=26, nfeat=13, nfft=512, rate=16000):
        self.mode = mode # You can configure mode to be conv, reccurent, etc.
        self.nfilt = nfilt
        self.nfeat = nfeat
        self.nfft = nfft
        self.rate = rate
        self.step = int(rate * SAMPLE_SECTION_VALUE) 
```

## Formatting X and y Labels into numpy arrays

- **Review:** `(# of rows, # of columns)` when getting the shape of a numpy array

- These values are fed into the model (Remember X is the input and y is the output since we are doing supervised learning)
- `np.amin(ndarray)`
  -  Parameter: A matrix
  -  Returns: Minimum value of matrix

```python
def build_features():
  	# Initial these lists to append each processed sample into them
    X = []
    y = []
    
     # Set to highest and lowest floats possible
     # We want initial values for min and max to start the tracking system in the for loop
    _min, _max = float("inf"), -float("inf")

    for i in tqdm(range(num_samples)):
        # Get random category with the probabilities we calculated (so that we can also account for wavfile lengths) 
        rand_category = np.random.choice(categories, p=prob_dist)

        # Get a random file that matches the class we just retrieved
        file = np.random.choice(df[df.label == rand_category].index)
        rate, wav = wavfile.read(os.path.join("clean", file))

        # Check if the wav file is even long enough to cover one section
        if wav.shape[0] < config.step:
            continue
        
        # Subtract config.step to ensure we do not run out of data nearing the end of a sample
        # In the next step, we are adding config.step, so we need at least config.step more room to increase
        random_idx = np.random.randint(0, wav.shape[0] - config.step)

        # Split out the sample you want to compute 
        # Random index we just retrieved plus the config.step
        sample = wav[random_idx:random_idx + config.step]

        # Calculate the mfcc
        # To get those heat map looking images in visualize for classification
        X_sample = mfcc(
            sample, 
            rate, 
            numcep=config.nfeat,
            nfilt=config.nfilt,
            nfft=config.nfft
        ).T # Transpose for proper shape in model (probably something you can see more clear later)
    
        _min = min(np.amin(X_sample), _min) # if we have a new minimum, update
        _max = max(np.amax(X_sample), _max) # if we have a new maximum, update
        
        X.append(X_sample if config.mode == "conv" else X_sample.T) 
        
        # Append category to y, but must map back to its index
        # y must be numbers to be converted into an array later (same goes for X)
        y.append(categories.index(rand_category))

    # Dimensions are (length_of_X, 13, 9)
    X_array, y_array = np.array(X), np.array(y)

    # Normalizes array values (0, 1)
    X = (X_array - _min) / (_max - _min)

    if config.mode == "conv":
        # Returns tuple:
            # X_reshaped[0].shape=X_reshaped[1].shape=(13, 9, 1)
            # len(X_reshaped) = length_of_X
        X_reshaped = X.reshape(X.shape[0], X.shape[1], X.shape[2], 1)
    elif config.mode == "recurrent":
        X_reshaped = X.reshape(X.shape[0], X.shape[1], X.shape[2])

    # One hot encoding linear variable (which is y)
    # Dimensions are (length_of_X, 10)
    y = to_categorical(y, num_classes=10)

    return X_reshaped, y
```

### One-Hot Coding

- Process by which categorical variables are converted into a form that could be provided to ML algorithms to do a better job in prediction
- Transforms categorical labels into vectors
  - Contains 0s and 1s
  - The length of vector = # of categories (so # of columns in array)
  - The height of vector = # of labeled data (so # of rows in array)
  - All elements in vector are 0 except for its category
  - eg. If we have these categories: `[cat, dog, lizard]`, then cat's vector would be `[1, 0, 0]`
- For categorical cross entropy





















