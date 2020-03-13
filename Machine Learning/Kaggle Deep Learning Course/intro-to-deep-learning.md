# Lesson 1: Intro to Deep Learning and Computer Vision

## How are images looked at by computers?

- Matrices
- Number in matrix represents darkness of image in that position (darker part &rarr; larger #)

## How are coloured images looked at by computers?

- Matrices, but with extra dimension (RGB)
  - Stack of 3 matrices

## Tensor

- Matrices with any # of dimensions (for e.g. matrices that images are represented by)

## Convolutions/Filters

- Refer to this [note](https://lauradang.gitbook.io/notes/machine-learning/convolutional-neural-networks/cnn-layers) for basic idea
- Detects edges/horizontal lines
- Since darker part &rarr; larger #, horizontal line results in larger numbers, other areas, result in smaller numbers
  - So we know there is an edge if the convolution outputs a large number!

**Examples**:

```python
# 2x2 Matrices
horizontal_line_conv = [[1, 1], [-1, -1]]
vertical_line_conv = [[1, -1], [1, -1]]
```

**Question**:

Which one is true?

- There are more visual patterns that can be captured by large convolutions
- There are fewer visual patterns that can be captured by large convolutions
- The number of visual patterns that can be captured by large convolutions is the same as the number of visual patterns that can be captured by small convolutions?

**Solution**:

There are more visual patterns that can be captured by large convolutions.

- Anything a 2x2 convolution can capture, a 3x3 convolution can also capture



