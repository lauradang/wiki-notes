# Training a Neural Network
Refer to [Intro to Neural Networks]([https://victorzhou.com/blog/intro-to-neural-networks/) 

**Big idea:** TRAINING NETWORK MEANS TO **MINIMIZE LOSS**

## Overall Process
1. Give outputs numbers (0 represents Male, 1 represents Female)
2. Shift data numbers by mean (normalization)
3. Calculate the **loss** function: Measure any mistakes between $$y_{true}$$ and $$y_{pred}$$.
4. Use **backpropagation** to quantify how bad a particular weight is at making mistake.
5. Use **optimization** algorithm that tells us how to change weights and biasses to minimize loss (e.g. **gradient descent**)

## Loss
- Quantifies how "good" network is at predicting
- Trying to minimize this

### Mean Squared Error
$$Squared Error = (ytrue − ypred)^2$$
**$$MSE=\frac{1}{n}∑ (ytrue − ypred)^2$$** - Takes average of squared error

## Adjusting weights and biases to decrease loss
Assuming we only have 1 item in dataset (for simplicity):

$$MSE=\frac{1}{1}∑ (1 − ypred)^2$$

$$MSE= (1 − ypred)^2$$

So $$L=(1 − ypred)^2$$

We can write **loss** as a *multivariable function of the weights and bias*:

$$L(w_1, w_2, w_3, w_4, w_5, w_6, b_1, b_2, b_3)$$

**Question**: How would tweaking $$w_1$$ affect loss? How do we find this out?
- Take partial derivative of $$L$$ with respect to $$w_1$$
  - i.e. Solve for $$\frac{∂L}{∂w_1}$$

## Solve for $$\frac{∂L}{∂w_1}$$
**$$\frac{∂L}{∂w_1}$$ = $$\frac{∂L}{ypred} \frac{∂ypred}{∂w_1}$$** - *Chain Rule*

So now, we must solve for $$\frac{∂L}{∂ypred}$$ and $$\frac{∂ypred}{∂w_1}$$

### Solving for $$\frac{∂L}{∂ypred}$$ (Easy!)

Remember $$L=(1 − ypred)^2$$, so simply

**Result**: $$\frac{∂L}{ypred}$$ = $$-2(1-ypred)^2$$

### Solving for $$\frac{∂ypred}{∂w_1}$$ (Not as obvious)

Remember that $$ypred$$ is really just the output.
From our neuron calculations before, output is just $$o_1$$

So to calculate $$ypred$$...

$$ypred = o_1$$
**$$o_1 = f(h_1*w_5 + h_2 * w_6 + b_3)$$** (Refer to the neural network diagram)

But even now, $$w_1$$ does not appear in this equation.. so we still can't solve properly, so we need to break this down even further.

Remember that we can also calculate $$h_1$$ and $$h_2$$ as...
$$h_1 = f(w_1*x_1 + b_1)$$
$$h_2 = f(w_2*x_2 + b_2)$$

Now we have $$w_1$$! Since we only see $$w_1$$ in $$h_1$$ (meaning that $$w_1$$ only affects $$h_1$$), we can just include $$h_1$$ So we can rewrite $$\frac{∂ypred}{∂w_1}$$ in a solvable form now.

**Result**: $$\frac{∂ypred}{∂w_1}$$ = $$\frac{∂ypred}{∂h_1}\frac{∂h_1}{∂w_1}$$

If you want to simplify this further...

$$\frac{∂ypred}{∂h_1}=f'(h_1*w_5 + h_2*w_6 + b_3)*w_5$$ 

$$\frac{∂h_1}{∂w_1}=f'(w_1*x_1+b_1)*x_1$$

Since we've seen $$f'(x)$$ multiple times, might as well solve for that too.
$$f(x) = \frac{1}{1+e^-x}$$

$$f'(x) = \frac{e^-x}{(1+e^-x)^2}=f(x)*(1-f(x))$$

So to sum it up...

## $$\frac{∂L}{∂w_1}=\frac{∂L}{∂ypred}\frac{∂ypred}{∂h_1}\frac{∂h_1}{∂w_1}$$

## Calculating $$\frac{∂L}{∂w_1}$$:
- Result is 0.0214
- Means that if $$w_1$$ increases, the loss also increases (only by a bit because it's a pretty flat slope) - think of a linear graph

## Optimization Algorithm
- Using [stochastic gradient descent](https://en.wikipedia.org/wiki/Stochastic_gradient_descent) (SGD)
  - $$w1​←w1​−η\frac{∂L}{∂w_1}$$
    - η is learning constant
  - If $$\frac{∂L}{∂w_1}>0 → w_1$$ decreases $$→ L$$ decreases
