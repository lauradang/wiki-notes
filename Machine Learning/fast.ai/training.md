# Training Learner

**Example**:

```python
learner = cnn_learner(databunch, pretrained_model, metrics=accuracy)
learn.fit_one_cycle(1,1e-2)
```

## Optimum Learning Rate

Refer to this [link](https://docs.fast.ai/callbacks.lr_finder.html#Suggested-LR)

#### What is Learning Rate?

- Hyper parameter that decides how much gradient should be back propogated
  - i.e. How much we move towards minimum
  - Small learning rate &rarr; Converge slowly to minimum
  - Large learning rate &rarr; Diverges

![](learningrate.png)

```python
learn.lr_find()
learn.recorder.plot(suggestion=True) # Draws where minimum numerical gradient is (which should be your learning rate)
```

- Choose value that is in the middle of the sharpest downward slope

## The 1cycle Policy

Refer to this [link](https://docs.fast.ai/callbacks.one_cycle.html#What-is-1cycle?)

- Similarly to the regular `learner.fit`, we need to find the optimum learning rate using `lr_finder`.