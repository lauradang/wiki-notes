# Convolutional Network Layers

A nice summary: [YouTube](https://www.youtube.com/watch?v=YRhxdVk_sIs)

## CNN Layers

- Detects patterns in images
- With each layer, number of filters must be specified
- Layer receives input, transforms input into outer layer

## Why should we use CNN for image classification over a NN?

### NNs have no Spatial Awareness (Loses 2D Space)

- Remember in PyTorch, we just convert the image to a 1D vector. The model then treats this vector as a simple vector of numbers when in reality, a picture is a 2D grid with different things in different places of the grid. So an NN is not aware of this which is very important when analyzing images since pixels that are closer to one another in a grid can be more related than pixels that are far apart. 

- e.g. The only reason an NN was okay for the MNIST handwriting dataset was because each number in the image of MNIST is in the exact same position, so spatial awareness isn't a factor for classification in this dataset.

### Redundancy in the connections between hidden nodes and input nodes:

![Fully Connected NN](nn.png)

Does a hidden node need to be connected to every input node like above? 

Not really. We could split it into sections (indicated by the colours) and have it connected like so instead:

![Sparsely connected network](nn-colour.png)

This way, there are way less connections and thus less calculations to make during training.This way, each node is responsible for finding patterns in their own spatial region as opposed to each node is responsible for finding all patterns in all spatial regions (That's what makes the NN way redundant).

**Note**: This is the meaning of **sparsely/locally** vs. **fully** connected layers. CNNs use sparesely connected layers while NNs use fully connected layers. We can also easily expand the number of patterns we want to find by introducing more hidden nodes like below.

![](cnn-colour.png)

### Images can be large

- If we were to pass in $$10^6$$ neurons per layer, that's a lot of operation
- CNN's extract features of images, then convert the image into lower dimension without losing its characteristics which will decrease the number of parameters the model needs to compute

![CNN Overview](cnn-overview.png)

## High Level Overview on Convolution on One Image

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

### Layers (i.e. layers of convolution)

Each set of convolutions applied at the same time is a layer.

1. **Layer 1**: Takes raw pixel intensities and translated into 3D tensor indicating where vertical/horizontal lines
2. **Layer 2**: Takes map from layer 1 as input, multiples by more 3D tensors to find more patterns
3. Continues on

## Input Layer

- See Input Layer Notes

## Convolutional Layer

- **High-Level Idea**
  - Feature extractor
  - Detects patterns (edge, corner, circle, square)
- Produced by applying series of filters to an image => which produces an image per filter
- These images are stacked and forms a convolutional layer with depth = # of filters applied
  - Makes the image "deeper" - Look at image above and see that rectangular prisms are getting deeper and skinnier (skinnier due to pooling)
- In the OpenCV notebook, we defined our own weights in the kernel. However, neural networks learn what the best weights are as they train.

### Filters/Kernels/Neurons in Convolutional Layers

- Uses:
  - Filter out irrelevant image information
  - Amplify distinguishing traits or object boundaries
- **Hyperparameter Tuning**
  - Increasing the **# of filters** increases the number of patterns your network will learn
  - Increasing the **size of filters** increases the size of detected patterns
  - Stride
  - Padding
- As you go deeper in the network, the filters become more complex and detailed
- Usually has ReLU activation function applied (which means this function is applied on all square of the feature map) to force all negative values to be 0
- Filter (all the same thing) starts in the top left corner of the input image and slides/convolving right across all areas of input image (Covers FxF area at a time)

![4x4 Image, 3x3 Filter, 2x2 Convolution](convolution.gif)

- Region FxF is the **receptive field**
- Also an array of numbers (aka the **weights**/**parameters**)
- What is happening as it shifts from one area to the next?
  - Multiplying values in filter with original pixel value of image and sum it all up
    - i.e. $$\Sigma(FilterValue*OriginalPixelValue)$$ - You get a single number from this entire area (hence why the dimensions shrink in the feature map)
- $$Convolution\space Dimension \space Result = N^2*F^2=(N-F+1)^2$$
  - $$N^2$$:  Image dimensions
  - $$F^2$$: Filter dimensions

### High-Pass Filters

- Sharpens image
- Enhances **high-frequency** parts of an image

### Edge Detection using Filters

- Convolutions + filters are used to detect edges
  - Darker part &rarr; smaller pixel value
  - Lighter part &rarr; larger pixel value

#### Frequency in Images

- High vs. low frequency images
  - High frequency images: Rapid changes in brightness (e.g. a striped shirt has black and white areas)
    - High frequency components in image help detect edges in image
  - Low Frequency images: Minimal changes in brightness (e.g. a blank white page)

#### High-Pass Filters

- Sharpens image and emphasizes edges
- Enhances **high-frequency** part of image (so the parts where rapid changes in brightness occur.. aka edges!)

![Result of High-Pass Filter](high-pass.png)

**Question**: Of the four kernels, which would be best for finding and enhancing horizontal edges and lines in an image?

![](4_kernels.png)

**Solution**: d) This kernel finds the difference between the top and bottom edges surrounding a given pixel.

**Question**: Which one is true?

- There are more visual patterns that can be captured by large convolutions
- There are fewer visual patterns that can be captured by large convolutions
- The number of visual patterns that can be captured by large convolutions is the same as the number of visual patterns that can be captured by small convolutions?

**Solution**: There are more visual patterns that can be captured by large convolutions.

- Anything a 2x2 convolution can capture, a 3x3 convolution can also capture, but the things a 3x3 convolution can capture, a 2x2 convolution cannot (it's smaller)

### Stride and Padding in Convolutions (Applies to both Pooling and Convolutional layers)

- Denotes # of steps we are moving in each steps in convolution (default is 1)

![Strides](strides.gif)

- Notice that size of output (feature map) is smaller than the input
- We use **padding** when we want to maintain the input shape's dimensions. 
  - The number in the padded squares are just 0s.

![Padding](padding.gif)

- Now you can see the size of the output is the same as the input!

$$Padding= \frac{F-1}{2}$$  &rarr; Padding is dependent on the dimension of filter.

If we set the above stride to 2, there would be times where the filter would be outside of the image. In these cases, we have two options:

1. Drop the unknown values that were outside the image. However, this risks not learning any information in certain parts of the image.
2. Use padding

## Max Pooling

A nice summary: [Youtube](https://www.youtube.com/watch?v=ZjM_XQa5s6s)

- **Reduces spatial volume of input image** AFTER convolution 
- Used between 2 convolution layers
  - Applying FC after Convo layer is computationally expensive
- In the input matrix, find the maximum value and that is your output feature value
- Why do we do max pooling?
  - Since max pooling reduces resolution of input, so it **reduces number of parameters a**nd computational load
    - Reducing the # of parameters also **prevents overfitting**

- If we have W x H x D, F is filter, S is stride (both hyperparameters)
  - **Dimensions of output after processed by Max Pooling Layer**:
    - $$W'=\frac{W-F}{S+1}$$
    - $$H'=\frac{H-F}{S+1}$$
    - $$D'=D$$
- Example:
  - Set filter size (eg. 2x2)
  - Set stride (eg. 2)
  - Find the maximum number in 2x2 matrix and store it in another grid (which is building to be the output), Keep going in intervals that was set by the stride

## Average Pooling

- Same as max pooling, but instead takes the **average** of the pixels that the filter covers
- Typically not used for image classification since max pooling is better for edge detection
  - Used for *smoothing* images

## Feature Vector

A series of numbers (a 1D matrix). It contains information describing an object's important characteristics. After the convolutional layers output specific features (e.g. for a car, it may output, there are wheels here), the feature vector will output this fact to make a classification.

## Dense Layers (Fully Connected Layers)

- Involved weights, biases, and neurons
- Connects 1 layer to neurons in another layer (shown in diagram above)

## Softmax/Logistic Layer

- Last layer
- Logistic/Sigmoid - Binary classification
- Softmax - Multiclassification

## Output Layer

- Contains label in form of one-hot encoded