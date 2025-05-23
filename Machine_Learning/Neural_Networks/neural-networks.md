# Neural Networks

Refer to [Introduction to Neural Networks](https://victorzhou.com/blog/intro-to-neural-networks/)

[Personal Code Example](https://github.com/lauradang/data-science-training/blob/master/neuron.py\)

## Neurons

**General Process**:
1. Takes input
2. Does some math
3. Outputs something

### Weights (Aka Parameters)
- Connects each neurons in one layer to the neurons in the next layer

### Activation Function
- Turns *unbounded* input into output that is *bounded* and thus, predictable
- eg. **Sigmoid function**

#### Sigmoid Function
$$\frac{1}{1+e^-x}$$
$$Range: [0, 1]$$
- eg. Binary classification: The output would either be 0 or 1

### What is happening in step 2 of process
1. Each input multiplied by some weight

**$$x_1$$ &rarr; $$x_1 * w_1$$**

2. All weighted inputs summed (basically dot product of input and weights) and bias is added

($$x_1 * w_1$$) + ($$x_2 * w_2$$) + $$b$$

3. Sum is passed into **activation function**

## Neural Network
- Neurons connected together

### Hidden Layer
- Layers between input and output layers