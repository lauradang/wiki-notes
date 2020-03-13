# Lesson 2: Building Models from Convolutions

**Review**: Convolution/Filter maps an output tensor that tells you where patterns show up in the image. Different convolutions map different patterns.

## Convolutions on One Image

### Stacking Convolutions

- Remember that 1 image can be represented by a matrix/2D tensor
- Each convolution applied on image creates a new matrix/2D tensor
  - These tensors are stacked into 1 3D tensor.
    - e.g. Stacking a convolution that detects horizontal lines on top of a convolution that detects vertical lines, etc.
    - **Result**: The image in 3D.

### Navigating through the Convolutional Tensors

- Moving horizontal across first tensor of 3D tensor:
  - Moving horizontal across image
- Moving vertical down first tensor of 3D tensor:
  - Moving vertical down image
- Moving from first tensor &rarr; second tensor &rarr; third tensor of 3D tensor:
  - Moving from one convolution output to another
  - **Channel** dimension

## Layers (i.e. layers of convolution)

- Each set of convolutions applied at the same time is a layer

1. **Layer 1**: Takes raw pixel intensities and translated into 3D tensor indicating where vertical/horizontal lines
2. **Layer 2**: Takes map from layer 1 as input, multiples by more 3D tensors to find more patterns
3. .... Continues on



