# Backpropagation / Reverse-mode Differentiation

Refer to [Calculus on Computational Graphs: Backpropagation
](https://colah.github.io/posts/2015-08-Backprop/)

### Prerequisite Knowledge
**Gradient Descent**: first-order iterative optimization algorithm for finding the global minimum of the cost function
- Derivatives of the cost with respect to all the parameters are used in finding gradient descent
  - i.e. Derivatives used to train models
- Millions of parameters in neural network

**Dependency Graphs**: Depicts how elements in codebase depend on one another (methods, types, namespaces, whole assemblies)

**Call Graphs**: Control flow graph of program, what functions call other functions. (i.e. Recursion is represented by cycles in call graphs)

## High Level Explanation
- Technique for calculating partial derivatives quickly
- Trains gradient descent faster in modern deep learning neural networks
- Algorithm reinvented many times
- Aka **reverse-mode differentiation**

## Computational Graphs
- Broken-down way of thinking about mathematical expressions

**Example**:
e = (a + b) ∗ (b + 1) 
=> c = a + b
=> d = b + 1
=> e = c ∗ d

### How to graph them (Refer to link for visualization)
- Each equation and input variables are nodes
  - i.e. the above equations and a and b
- Arrows point from input to equation with that input
- Can also set specific values to variables so that each node has corresponding value 
- The "top" node is what the expression evaluates to

### Applications
- Dependency graphs
- Call graphs
- Abstraction behind deep learning framework `Theanos`

## Derivatives on Computational Graphs
- Want to see how variables change the equation
  - i.e. how the node pointing to another node affects the node that is pointed at
  - This is the **Partial Derivative** which is labeled on the graph edges (the arrows)
- To understand how nodes that are not directly connected affect each other, use the **sum over paths** rule
  - multiply derivatives of each edge on each path and sum all the paths up (again refer to website)

## Factoring Paths
- Reduces combinatorial explosion into more condensed way
**Example**:
- Say we have 3 nodes, 3 paths between each nodes => 9 different paths are possible
  - i.e. This can get very large if the # of nodes increase or the # of paths between each node increases (exponential growth)

We have **∂Z/∂X = αδ + αϵ +αζ + βδ + βϵ + βζ + γδ + γϵ +γζ**
This can be factored/reduced to: **∂Z/∂X = (α+β+γ)(δ+ϵ+ζ)**

- Forward-mode/Reverse-mode differentiation both compute the same sum more efficiently using this method
- Touch edges exactly once
### Forward-mode Differentiation
- Starts at input
- Moves towards end
- Sums all paths feeding into next node
- Each path represents how input affects node (derivative
- **Summary**: Tracks how 1 input affects every node
  - i.e. Applies **$$\frac{∂}{∂X}$$** to every node

### Reverse-mode Differentiation
- Starts at output
- Moves towards beginning
- At each node, merges paths which originated at that node
- **Summary**: Tracks how every node affects 1 output
  - i.e. Applies **$$\frac{∂Z}{∂}$$** to every node

## Seeing the Advantages of Reverse-mode Differentiation
- Refer to diagram in this section
- Forward-mode differentiation gave derivative of output with respect to *one input*
  - i.e. This way, you have to go through the nodes multiple times to cover all inputs
- Reverse-mode differentiation gives us *all inputs*.
  - i.e. This way, you only go through the nodes once to get the information
- For indicated graph, factor of 2 speed-up (can be much more if there are millions of nodes and paths)

**Note**:
- Forward-mode differentiation can still be faster than reverse-mode differentiation
  - eg. If there is one input and many outputs in neural network

### Other Benefits of Backpropogation
- Helps to see the flow of networks
- Can see why some models are hard to optimize
  - eg. Vanishing gradients in RNNs













