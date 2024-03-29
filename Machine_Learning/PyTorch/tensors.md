# Tensors

## What is a tensor?
- Similar to `numpy`'s n-d arrays
- Can be used on GPU

## Tensor Attributes
Each `torch.Tensor` has these:
1. [`torch.dtype`](https://pytorch.org/docs/stable/tensor_attributes.html#torch.torch.dtype "torch.torch.dtype")
2. [`torch.device`](https://pytorch.org/docs/stable/tensor_attributes.html#torch.torch.device "torch.torch.device")
3. [`torch.layout`](https://pytorch.org/docs/stable/tensor_attributes.html#torch.torch.layout "torch.torch.layout")

### `torch.dtype`
- Object
- Represents data type of the tensor
- [`is_floating_point`](https://pytorch.org/docs/stable/torch.html#torch.is_floating_point "torch.is_floating_point") returns boolean of whether a tensor is a floating point data type

#### Operations with Tensors
When the dtypes of inputs to operation (add,sub,div,mul) **differ**, find the **minimum dtype** that satisfies the following rules:

**Tensor Operands**: floating > integral > boolean

1. If type of a scalar operand > tensor operands 
  &rarr; Promote to type with sufficient size to hold all scalar operands of that category.

2. If a 0-dimension tensor operand > dimensioned operands
  &rarr; Promote to type with sufficient size and category to hold all 0-dim tensor operands of that category.

3. If there are 0 higher-category zero-dim operands
  &rarr; Promote to type with sufficient size and category to hold all dimensioned operands

### `torch.device`
- Object
- Represents device that the tensor is allocated
- Cuda
  - Keeps track of selected GPU


```python
>>> torch.device('cuda:0')
device(type='cuda', index=0)

>>> torch.device('cpu')
device(type='cpu')

>>> torch.device('cuda')  # current cuda device
device(type='cuda')
```

### `torch.layout`
- Object
- Represents memory layout of tensor
- Perform tensor operations efficiently

