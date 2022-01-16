# Kullback-Leibler Divergence

Refer to this [link](https://machinelearningmastery.com/divergence-between-probability-distributions/).

Often in ML, we are interested in calculating the difference between the actual and predicted probability distributions.

We can do this using KL Divergence. It calculates a score that measures the divergence of one probability distribution from another.

The KL divergence between two distributions Q and P is often stated using the following notation:

$$KL(P || Q)$$

Where the “||” operator indicates “*divergence*” or Ps divergence from Q.

$$KL(P || Q) = –\int  P(x) * log\frac{P(x)}{Q(x)}\space dx$$

## Code Implementation

```python
# Define distributions
events = ['red', 'green', 'blue']
p = [0.10, 0.40, 0.50]
q = [0.80, 0.15, 0.05]
print('P=%.3f Q=%.3f' % (sum(p), sum(q)))

# Plot first distribution
pyplot.subplot(2,1,1)
pyplot.bar(events, p)
# Plot second distribution
pyplot.subplot(2,1,2)
pyplot.bar(events, q)
# Show the plot
pyplot.show()

# Calculate the kl divergence
from math import log2
def kl_divergence(p, q):
	return sum(p[i] * log2(p[i]/q[i]) for i in range(len(p)))

# Calculate (P || Q)
kl_pq = kl_divergence(p, q)
print('KL(P || Q): %.3f bits' % kl_pq)

# Calculate (Q || P)
kl_qp = kl_divergence(q, p)
print('KL(Q || P): %.3f bits' % kl_qp)
```

