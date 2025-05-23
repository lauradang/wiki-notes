# Audio Classifier Tutorial

Refer to this [Google Colab Notebook](https://colab.research.google.com/github/pytorch/tutorials/blob/gh-pages/_downloads/audio_classifier_tutorial.ipynb#scrollTo=btLtg0qkCd3B)

## Prerequisite Knowledge
**Sampling Frequency**:# of samples per second
eg. if the **sampling frequency** is 44100 hertz, a recording with a duration of 60 seconds will contain 2,646,000**samples**.

## Dataset (UrbanSound8K)
- 10 Folders in total
- 9 Folders to train
- 1 Folder to test

## Formatting the Data
Create **wrapper class** called `UrbanSoundDataset` that is a subclass of `torch.utils.data.Dataset`:

**Fields** (stores ____ of audio files when an object is instantiated)
- File names
- Labels
- Folder number

**Methods**:
`__getitem__`
- Used to load and format data
- Uses `torchaudio.load()`
  - Converts `.wav` files to tensors
  - Returns tuple (tensor, sampling frequency of audio file - 44100Hz)
- Uses `torchaudio.transforms.DownmixMono()`
  - Dataset has audio in 2 channels, this makes it into 1 channel
- Network takes input size of 32,000 samples (only 0.7 seconds), but most audio files in dataset have 100,000 samples)
  - Downsample to 8000Hz (32,000 samples now spans 4 seconds)
    - Achieved by taking every 5th sample of original audio tensor
      - Not every audio tensor long enough to handle downsampling (these tensors will be padded with 0s)
    - Minimum length that won't require padding is **160,000 samples** (32,000*5)




















