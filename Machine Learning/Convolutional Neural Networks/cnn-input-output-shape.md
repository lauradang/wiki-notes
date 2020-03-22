# Input/Output Shape for Convolutional Neural Networks

Refer to this [link](https://towardsdatascience.com/understanding-input-and-output-shapes-in-convolution-network-keras-f143923d56ca).

## Input Shape

You need to ensure that all images are the same dimensions. Usually the images are squares with dimensions by powers of 2.

- 4D Array of Image
  - `(batch_size, height, width, depth)`

## Displaying Input Image

```python
from PIL import Image
import matplotlib.pyplot as plt

### Displaying image from direct path ###
image = Image.open(img_path).convert("RGB")
plt.imshow(image) 

### Displaying image from http ###
import requests 
response = requests.get(http_address)
image = Image.open(BytesIO(response.content)).convert("RGB")
plt.imshow(image) 

### Displaying multiple images in one row ###
f, axarr = plt.subplots(1,2) # plt.subplots(# of rows, # of columns)
axarr[0].imshow(Image.open(STYLE_IMG).convert("RGB")) 
axarr[1].imshow(Image.open(CONTENT_IMG).convert("RGB"))

## Could also do the above it like this ##
fig, (ax1, ax2) = plt.subplots(1, 2)
ax1.imshow(im_convert(content))
ax2.imshow(im_convert(style))

### Displaying tensor as an image ###
image = tensor.to("cpu").clone().detach()
image = image.numpy().squeeze()
image = image.transpose(1,2,0)
# These normalization values must match your respective model
image = image * np.array((0.229, 0.224, 0.225)) + np.array((0.485, 0.456, 0.406))
image = image.clip(0, 1) # now the image can be treated like an Image.open()

```

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

