# Multivariate Linear Regression

This is linear regression, but with multiple variables. So we have a new hypothesis function!

## Hypothesis: $$h_\theta(x)=\theta_0+\theta_1x_1+...+\theta_{n-1}x_{n-1}+\theta_nx_n=\theta^Tx$$ 

## Parameters: $$\theta_0, \theta_1, ... ,\theta_n=\theta\in\R^{n+1}$$

## Variables: $$x_0, x_1,...,x_n=x\in\R^{n+1}$$

e.g. Think of each variable as a different feature. $$x_1$$ could be square footage, $$x_2$$ could be number of floors, etc.

## Gradient Descent for Multiple Variables

Repeat until convergence {

​	$$\theta_0:=\theta_0-\alpha\frac{1}{m}\Sigma\space ((h_\theta(x^{(i)})-y^{(i)})x_0^{(i)})$$

​	$$\theta_1:=\theta_1-\alpha\frac{1}{m}\Sigma\space ((h_\theta(x^{(i)})-y^{(i)})x_1^{(i)})$$

​	$$\theta_2:=\theta_2-\alpha\frac{1}{m}\Sigma\space ((h_\theta(x^{(i)})-y^{(i)})x_2^{(i)})$$

​	...

}

We can condense this down to:

### Gradient Descent Algorithm for Multiple Variables:

Repeat until convergence {

​	$$\theta_j:=\theta_j-\alpha\frac{1}{m}\Sigma\space ((h_\theta(x^{(i)})-y^{(i)})x_j^{(i)})$$ for $$j=0,1,2,..,n$$

}

