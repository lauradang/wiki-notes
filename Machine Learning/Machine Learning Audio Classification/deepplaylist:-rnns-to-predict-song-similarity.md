# DeepPlaylist: RNNs to Predict Song Similarity
Notes on [this paper](https://cs224d.stanford.edu/reports/BalakrishnanDixit.pdf)

## Motive
- Want to suggest songs based on actual song content
- With current recommenders, less popular artists aren't as recommended

## Related Work
- **Collaborative Filtering**
  - Analyzes patterns in usage data
  - 2 Problems:
    - Needs a lot of human data
    - Capitalistic nature (makes the popular songs even more popular and leaves the niche ones unlistened)
- **Solutions to the above Problems:**
  - Precomputed convolutional filters + MLP 
    - Kong, Feng and Li Kong et al.
    - 73% genre classification on Tzanetakis1 dataset
  - CNNs on raw audio vs. spectrogram input => spectrogram input gave better results
    - Sander Dieleman

## Approach
We will try to find similarity between lyrics or actual sound.
### Problem Statement
**Setting up variables**:
Let P and Q represents two songs which are both sequence of vectors.

$$P = (P_1, ..., P_n)$$ 
$$Q = (Q_1, ..., Q_m)$$

**$$P_i$$** represents:
- Word vector $$x_i$$ of the ith word in the lyrics of song P

**$$Q_i$$** represents:
- Audio spectrogram for a fixed # of frames for the $$t$$th "chunk" of time in song Q

Let Y be an indicator (0 is not similar, 1 is similar): $$Y ∈ [0, 1]$$

**Classification Problem**: $$y=f(P, Q)$$
- **$$f(P, Q)$$** is non-linear classification function (Predicts similarity between songs)

## Models
- Why **LTSM**?
  - Audio is sequential
  - Able to remember longer sequences than normal RNNs

#### Framework
- **Input to models**: $$P$$ and $$Q$$ (remember these are the two songs)
- **Output of model**: 1 Classification label, $$y$$
- On top of LTSM, added layers depending on input (either lyrics, so text, or audio)
- For audio, before being passed to LTSM, process through convolutional layers

Overall Process:
1. Input for each song (so either the lyrics or audio) unrolled 1 timestep at a time spectrogram data through network
2. Final hidden states from each song ($$P$$ and $$Q$$) are combined
3. Result is passed through 1 or more fully connected layers and finally a softmax function
4. Produces single binary output

## Experiments
### Dataset
- Million Song Dataset (MSD) 
  - Links to LastFM Dataset (over 500,000 similar song matches)
  - Has similarity score between 0 to 1 (our threshold is **0.5**)
  - Can also query for songs through their API (useful for lyric and audio samples)
- 54412 songs => 6240 audio samples
  - 1000 audio dataset pairs
  - 38 000 lyric dataset pairs
  - Split into training and validation sets (both have equal number of similar and not similar data points)
- Stored audio samples as `.wav` files
- Converted audio samples to `NumPy` arrays using `SciPy`
- Split data into blocks of 11025 values
- Computed absolute value of Fast Fourier Transform of this data to be used as the input to model

### Audio Model Configurations
Look at Table 3

### Hidden State Combinations
- Concatenation and Absolute difference were equivalent

### Convolutional Layers
Start with [Amodei et al., 2015]





















