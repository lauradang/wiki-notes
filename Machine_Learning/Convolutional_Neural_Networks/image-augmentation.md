# Data Augmentation

For an image classification problem, we are only concerned if the object is present in the image. We do not care if it's rotated (**rotation invariance**), flipped, to the right or left (**translation invariance**), We basically want our algorithm to learn an **invariant representation** of the image. We also do not want our model changing its prediction based on the size of the object (**scale invariance**).

**So how do we make our algorithm good with invariant representation of images?**

We just need to feed the training network with rotated/flipped/translated/scaled images.