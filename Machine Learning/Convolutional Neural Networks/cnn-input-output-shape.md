# Input/Output Shape for Convolutional Neural Networks

Refer to this [link](https://towardsdatascience.com/understanding-input-and-output-shapes-in-convolution-network-keras-f143923d56ca).

## How are images looked at by computers?

- Matrices
- Number in matrix represents darkness of image in that position (darker part &rarr; larger #)

## How are coloured images looked at by computers?

- Matrices, but with extra dimension (RGB)
  - Stack of 3 matrices

## Input Shape

- 4D Array of Image
  - `(batch_size, height, width, depth)`

## Batch Size

#### Specifying batch size in CNN

```python
model.add(Conv2D(64, kernel_size=1, batch_input_shape=(16, 10, 10, 3)))
```

#### Specifying batch size when fitting (default batch size will be `None`)

```python
model.add(Conv2D(64, kernel_size=1, input_shape=(10, 10, 3))) # This is not 3D Array! Batch_size is just set to None as default
...
model.fit(X, y, epochs=10, batch_size=16)
```

### Depth of an image

- Number of colour channel
  - **RGB**: $$Depth = 3$$
  - **Greyscale**: $$Depth = 1$$

## Output Shape

- 4D Array 
  - `batch_size` always stays the same as input (even when **Flattening**)
  - The rest change based on filter, kernal size, padding, etc.

### Changing dimensions of Output Shape

- Usually, **Dense** layers are added on top of **Conv** layers for classification, but **Dense** layers take in a 2D array
  - So you must **Flatten** before adding a **Dense** layer to change the dimensions to 2D array.

