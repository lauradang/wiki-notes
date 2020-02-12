# Recurrent Neural Networks (RNN)

**What is a neural network?**
- set of algoriths designed to recognize patterns

### Artificial Neural Network (ANN)
- Has layers
- First layer receives raw input information
- Inner layers process raw input
- Last tier produces output


### How does RNN make decisions?
- Performs same function for every input of data
- Output of input depends on past one computation
- After output is produced, output is copied and sent back into RNN
- Makes decision by considering current input and output that it has learned form previous input 
  - Decisions based on what it learned from past

**Example**:
Sequence of input: x(n)
1. Takes X(0) from sequence of input
2. Outputs h(0)
3. h(0) and X(1) is the input for the next step (i.e. [h(0), X(1)] is 1 vector)
4. Goes through activation function
5. Outputs h(1)
6. h(1) and X(2) is the input for the next step
7. Continues..

### Compare NN to RNN
| network | input              | output                              |
|---------|--------------------|-------------------------------------|
| NN      | Fixed sized vector | Fixed sized vector                  |
| RNN     |                    | Series of vectors (no pre-set size) |
