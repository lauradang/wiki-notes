# Introduction to GAN

Refer to [Understanding GANs](https://towardsdatascience.com/understanding-generative-adversarial-networks-gans-cd6e4651a29).

A good visualization can be found [here](https://youtu.be/6v7lJHFaZZ4).

## Outline

- How do we generate random variables from a distribution?
- How can GANs be expressed as a random variable generation problem?
- What are matching-based generative networks?
- How do we implement a GAN?

## Generating Random Variables

- Use pseudorandom number generator 
  - Generates sequence of numbers that approximately follow a uniform random distribution between 0 and 1
  - **Review**: Uniform random distribution is one where all outcomes are equally probable. &rarr; $$f(x)=\frac{1}{b-a}$$ (Notice how $$f(x)$$ is not dependent on the value of $$x$$, so for all $$x$$ values, $$f(x)$$ is the same)

## How do we generate random variables?

Different techniques: Inverse transform method, Rejection sampling, Metropolis-Hasting algorithm

### Inverse Transform Method

Let X be a random variable we want to sample from.

Random variable defined by CDF &rarr; $$CDF_X(x)=P(X\le x)$$

Since we are dealing with uniform distributions, then

$$CDF_U(u) = P(U\le u ) = \int_a^{u}\frac{1}{b-a}=\frac{u-a}{b-a}$$, where $$a \le x \le b$$. 

Since $$u \sim U(a,b)$$ where $$a=0, b=1$$, $$CDF_U(u)=u$$.

Now, we supposed that $$CDF_U(u)$$ is invertible. So we can define $$Y=CDF_X^{-1}(U)$$

$$CDF_Y(y)=P(Y\le y)=P(CDF_X^{-1}(U)\le y)=P(U \le CDF_X(y))=CDF_X(y)$$.

So we have $$CDF_Y(y)=CDF_X(y)$$. Since Y and X have the same CDFs, they also define the same random variable.

**Summary**: This method generates a random variable that follows a given distribution. As shown above, we manipulated (inverse CDF) Y to follow the same distribution, and hence generate the same random variables, as X. In our case, the given distribution was the uniform random distribution.

## Generating Random Variables using GANs

Let's explain this with an example. Suppose we want to generate nxn dog images. We can break this down into $$n$$ vectors. Each of these $$n$$ vectors will either fit the probability distribution of what a dog looks like or not. In other words, there exists a specific probability distribution for a dog image (same as there is a probability distribution for a bird or cat).

**The Defined Problem**: The problem of *generating* a dog image, means we need to generate a vector that fits the probability distribution for a dog. In other words, we need to generate a random variable with respect to the probability distribution of a dog.

**Issues that will be addressed**:

- "dog probability distribution" is very complex over a large space
- How do we explicitly express this dog probability distribution?













