# Groundbreaking Convolutional Neural Network Architectures

## ImageNet

Over 1 million images of 1000 classes of images. Here are some models that performed extremely well with this dataset.

## AlexNet (2012)

- Pioneered usage of ReLU and Dropout to avoid overfitting
- Had large convolutional filters (11x11)
- By UofT

## VGG (2014)

- VGG-16, VGG-19 
- Long sequence of 3x3 convolutional, 2x2 Pooling, 3 FC layers
- Pioneered usage of small 3x3 convolutional filters
- By Oxford University

## ResNet (2015)

- ResNet-152
  - With the enormous # of layers, Vanishing Gradient Problem was discovered
  - They solved this by adding skip layers which shortened the route for gradients to travel (initially, the gradients had to travel the entire 152 layers which is a lot)
- By Microsoft Research