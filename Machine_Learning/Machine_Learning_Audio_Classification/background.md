# Background
Refer to [this video](https://www.youtube.com/watch?v=Z7YM-HAz-IY&list=PLhA3b2k8R3t2Ng1WW_7MiXeh1pfQJQi_P)

## Preprocessing
![Wave-form-time-domain-to-Fourier-transform-frequency-domain-of-the-DGServo-S06NF.jpg](https://www.researchgate.net/profile/Nikolas_Martelaro/publication/314165058/figure/fig5/AS:668383167127553@1536366373081/Wave-form-time-domain-to-Fourier-transform-frequency-domain-of-the-DGServo-S06NF.jpg)
### Reading Audio Files
**Use Librosa**
- `librosa.load()` &rarr; (array of amplitudes, sampling rate)
  - Sampling rate is also sampling frequency (samples/sec)

```python
samples, sampling_rate = librosa.load(file_path)

# Length of audio file:
len(sample) / sampling_rate
```
### Visualizing Audio
- Plotting the **Time Domain**
  - Amplitude (loudness) against time
- Not very useful itself, but we can transform this into the **Frequency-Domain** which is more useful (Process is **Fourier Transform**)
```python
from librosa import display
plt.figure()
librosa.display.waveplot(y=samples, sr=sampling_rate)
plt.xlabel("Time (seconds) -->")
plt.ylabel("Amplitude")
plt.show()
```

## Fourier Transform (FT)
- Transformation from Time Domain → Frequency Domain 
- Takes **continuous signal** as input
- Decomposes signal into constituent frequencies
- Returns 2 components:
  - Frequency
  - Magnitude of frequency

### Downsampling
- Frequency data domain gets irrelevant after a certain point (the ends have smaller amplitude) 
  - Microphones do not pick up on these frequencies 
- When **downsampling**, we can omit these irrelevant data points in the frequency domain

## Fast Fourier Transform (FFT)
- Takes **discrete signal** as input
- Uses **Discrete Fourier Transform (DFT)**
  - Does the same thing FT does but with discrete input

### Short-time Fourier Transform
- Take small moment in time of audio 
- Conventional window length: 0.025 seconds
- Conventional step size: 10ms
- N FFT: 512 samples (in powers of 2)
- Imagine window length being placed on top of the frequency domain, and the FFT sections out the windows whcih produce a spectrogram

## Spectrogram 
- Shows magnitudes in frequency domain 
- More intense bands indicate higher amplitudes

## Mel Filterbank
- High frequencies are indistinguishable to humans
- Filters what would be considered important to humans when classifying sounds 
- In graph below, we have "binned" bank in 10 filters
- Creates **features** for ML based on the frequency domain
  - Gives values that are highly correlated
![YuQ_ODh7R6K2nX-1tQ-flBqXq41rDNS3qpfJYS3p8r5Y7MRX-usWJoRxBv4ZwoagufjUPSjDVyMSiU0IkF9Ovq7JDYN9AilbtGvFdIieh_FMh90QF7LBt8gbTmmn7ktpWh4S9g](https://lh3.googleusercontent.com/proxy/YuQ_ODh7R6K2nX-1tQ-flBqXq41rDNS3qpfJYS3p8r5Y7MRX-usWJoRxBv4ZwoagufjUPSjDVyMSiU0IkF9Ovq7JDYN9AilbtGvFdIieh_FMh90QF7LBt8gbTmmn7ktpWh4S9g)

## Feature Engineering
- Do discrete cosine transform on the above filterbank and we get **Mel Cepstrum Coefficients**
  - This compacts and compresses audio to filter out higher frequencies (only keeping lower frequencies)
  - All the instruments kind of have their own unique "fingerprint" at this point
  - So a machine could easily differentiate at this point
  
![visualize_dic_instrument.png](https://ccrma.stanford.edu/~juhan/thesis/visualize_dic_instrument.png)