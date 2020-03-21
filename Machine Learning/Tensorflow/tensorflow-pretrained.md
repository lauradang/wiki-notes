# Training Images on Pretrained Models

## Preprocessing Images

1. Put path of all images in a list
2. For all images, load image

```python
from tensorflow.python.keras.preprocessing.image import load_img
imgs = [load_img(img, target_size=(height, width), for img in imgs)]
```

3. Convert images into 3D tensors (an image is a 3D tensor as seen in the last lesson) using Keras `img_to_array()`. Multiple 3D tensors stack together to form another array. 

```python
import numpy as np
from tensorflow.python.keras.preprocessing.image import img_to_array
img_array = np.array([img_to_array(img) for img in imgs])
```

4. Do some arithmetic on the new array using `preprocess_input()`. Squishes values to $$[-1, 1]$$ since the pretrained model resnet also had these values.

```python
from tensorflow.python.keras.applications.resnet50 import preprocess_input
output = preprocess_input(img_array)
```

## Predicting using Pretrained Models

```python
from tensorflow.python.keras.applications import ResNet50

my_model = ResNet50(weights='../input/resnet50/resnet50_weights_tf_dim_ordering_tf_kernels.h5')
test_data = read_and_prep_images(img_paths)
preds = my_model.predict(test_data)
```