# Introduction to Neural Networks

[MNIST Jupyter Notebook](http://localhost:8888/notebooks/ML/MNIST.ipynb)

### Goal of Network
- Have an input that is going to be mapped to an output
- eg. Input: X1, X2 -> Dog, Cat (Two Neurons)

### How do we achieve this goal?
#### Neural Network Overview
- Through hidden layers with neurons
- Each input will map to each neuron in hidden layer
- Connection between input and neuron have its own unique weight
- One hidden layer between input and output is linear relationship (not complex enough for most cases)

![alt text](/Users/lauradang/Desktop/neuralnetwork.png "Neural Network")

#### Neurons
- Summed together
- If summation meets certain condition, neuron is fired/activated (spike in segway function - returns value between 0-1)
- Each neuron output will be a segway function between 0-1 (entire layer will add up to 1)

![alt text](/Users/lauradang/Desktop/neurons.png "Neurons")
