# Convolutional Neural Networks

[YouTube](https://www.youtube.com/watch?v=YRhxdVk_sIs)

## Convolutional layers

* Detects patterns in images
* With each layer, number of filters must be specified
* Layer receives input, transforms input into outer layer

## Filter

* Detects patterns
  * Eg of pattern is \(edge, corner, circle, square\)
* Geometrical filters are usually the layers at the service of network
* As you go deeper, the filters become more complex and detailed
* can be thought of as a small matrix

  **Example of specifying number of filters in a layer**

* One 3x3 Matrix initialized with random numbers is an example of a filter
* Layer will receive this input and filter will slide over every 3x3 set of pixels from input itself until its slid over all 3x3 in the image \(convolving \(filter convolves across each 3x3 pixel in image\)\)

[Youtube](https://www.youtube.com/watch?v=ZjM_XQa5s6s)

## Max pooling

* Added after convolutional layer
* Reduces dimensionality by reducing the number of pixels from the previous convolutional layer
* Set filter size \(eg. 2x2\)
* Set stride \(eg. 2\)
* Calculate max in 2x2 box and store it in another grid .. Keep going in interbals that was set by the stride 

  **Why do we do max pooling?**

* Since max pooling reduces resolution of input, network will be looking at larger areas of the image \(reduces number of parameters and computational load in network\)
* Helps to reduce overfitting
* Since convolutional layers look for specific things, the higher number in the layer can be seen as more activated, so with max pooling \(it extracts the highest numbers in the layer\). We are able to pick out the most activated pixels while discarding not as activated pixel\)

