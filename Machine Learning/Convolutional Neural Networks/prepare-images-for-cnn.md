# Prepare Images for CNN

## Reshaping Numpy Arrays

```python
# images is a list of floats/integers that represent an image
images = np.array(images, dtype = 'float')  
```

- We have a numpy array (`images`) of these dimensions: `(x, )`
  - Need 4D array for input shape whose product is $$x$$
  - So we can take $$\sqrt{x}$$ and reshape as:

```python
np.reshape(-1, sqrt(x), sqrt(x), 1) # 1 if the image is greyscaled
```

## Plotting Images as Numpy Arrays

```python
import matplotlib.pyplot as plt
plt.imshow(images_reshaped[0].reshape(sqrt(x),sqrt(x)),cmap='gray')
plt.show()
```

## Creating Labels with Numpy Arrays

```python
# Isolate dataframe to only have the labels
y = []
for i in range(len(df)):
  y.append(np.array([labels_df.iloc[i,:]], dtype='float'))
```



