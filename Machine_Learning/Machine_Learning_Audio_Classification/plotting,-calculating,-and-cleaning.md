# Plotting, Calculating, and Cleaning
[Refer to this Link](https://www.youtube.com/watch?v=mUXkj1BKYk0&list=PLhA3b2k8R3t2Ng1WW_7MiXeh1pfQJQi_P&index=3)

## Calculating Fast Fourier Transform
- Remember FFT has 2 components (frequency and magnitude of frequency)
- `np.fft.rfftfreq(window_length, d=inverse_sampling_rate) -> Returns ndarray of sampling frequencies`
- `np.fft.rfft(discrete_signal_input) -> Returns COMPLEX ndarray`
  - Since it returns a complex array, it has an imaginary part, but we only want the magnitude (so only the real). So we take the absolute value
  - Dividing by window_length to normalize the FFT output (not required but good to do)
    - Even though we should be ensuring that all signals are the same length, in case they aren't, this scales magnitude of the FFT

```python
def calc_fft(samples, sampling_rate):
    window_length = len(samples)
    frequency = np.fft.rfftfreq(window_length, d=1/sampling_rate)
    magnitude = abs(np.fft.rfft(samples) / window_length)

    return (magnitude, frequency)
  
samples, sampling_rate = librosa.load(file)
calc_fft(samples, sampling_rate)
```

## Calculating the Filterbank Energy Coefficients and Mel Frequency Cepstrum Coefficients
- **Filterbank**:`logfbank(audio signal that is n*1 array, sampling_rate, nfft)`
  - `nfft`: the FFT size (number of bins used for dividing the window into equal strips, or bins)
- **Cepstrum**: Similar to above but uses `mfcc()` (Remember, this is just the filterbank energy coefficients with the discrete cosine transform)
    - Calculated by $$sampling frequency*window_size$$
    - Get the sample frequency by getting the rate from `wavfile.read()`
    - Here, we just used the conventional window size of 0.025 seconds
    - So the `nfft=44100*0.025`

```python
from python_speech_features import logfbank, mfcc

samples, sampling_rate = librosa.load(file)

bank = logfbank(
  samples[:sampling_rate], 
  sampling_rate, 
  nfft=sampling_rate/window_size_in_seconds
)

coeff = mfcc(
  samples[:sampling_rate], 
  sampling_rate, 
  nfft=sampling_rate/window_size_in_seconds
)
```

## Analyzing Plotted Graphs
### Time Series
**Noise Threshold Detection**
- Remember in `Background and Downsampling`, we can see where there is low magnitude portions (quieter sound) and we should filter this out
  - Barely any signal for algorithm to process
- **General Idea**: Compute a threshold, if sample does not meet this threshold, it is filtered out

### Fourier Transform
- Frequencies are so distributed, you can't tell much :sad:

### Filterbank Coefficients and Mel Cepstrum Coefficients
- Can now distinguish between instruments pretty well visually

## Calculating Threshold Envelope of the Signal to Clean Dead Space
![Signal_envelopes.png](https://upload.wikimedia.org/wikipedia/commons/3/31/Signal_envelopes.png)
- Want to detect the red lines (this is called the **Rolling Mean**)
  - Do this easier with `Pandas Series` instead of `numpy array`
  - Returns List of booleans for Numpy array Masking (Lines up with numpy array length, if the index is matched up with False, it is removed from the array)
- To find threshold value (in this case it's 0.0005), you have to test out which one works best

```python
def calc_envelope_signal(samples, sampling_rate, threshold):
    # Convert numpy array to Series for easier data manipulation
    samples = pd.Series(samples).apply(np.abs)
    samples_mean = samples.rolling(
        int(sampling_rate/10), 
        min_periods=1,
        center=True
    ).mean()

    return [True if mean > threshold else False for mean in samples_mean]

signal = np.array([2, 3, 2, 4])
calc_envelope(signal, 44100, 0.0005) 
>> [True, True, False, False]

signal = signal[calc_envelope(signal, 44100, 0.0005)]
>> np.array([2, 3])
```















