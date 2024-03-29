# LSTM Networks (Long-Short Term Memory)

**Review**: Gradient is the value used to update weights

## Problems with RNN
- Short-term memory
  - RNNs may leave out important information from beginning when analyzing a huge paragraph
- Vanishing gradient problem - Gradients get so small, weights don't get updated very significantly - so no learning is done
  - Early layers in RNNs suffer from this (since early layers can't learn, RNNs forget what it saw in longer sequences)

## Solution: LSTM and GRU
- Have internal mechanisms called gates (regulates flow of info by seeing what info to keep or throw away) 
  eg. Compare to your brain when looking at a paragraph, you only really remember the key words and main ideas

## LSTM

![LTSM](https://upload.wikimedia.org/wikipedia/commons/3/3b/The\_LSTM\_cell.png)

### Components
- Cell State
- Gates (Forget Gate, Input Gate, Output Gate)

### Cell State
- Memory of the network
- Carries information during sequence processing from really early times **

### Gates
- Different NNs that decide what's important (to keep or forget during training)
- Contains sigmoid activation functions
  - Helpful because any # multiplied by 0 is just forgotten (Uses vanishing gradient problem to our advantage)

### Step-by-Step Flow
**Review**: Hidden state is information from previous inputs ($$h_1$$ for example)

#### Forget Gate
- **Overall**: Decides what info should be forgotten or kept
- Outputs values between 0 and 1 since it has a sigmoid function
  - 0 is forgotten
  - 1 is kept

#### Input Gate
- **Overall**: 
  - Updates the cell state
  - Decides what values should be updated in info passed from forget gate
- Again sigmoid, so outputs values between 0 and 1
- While this ^ happens, also passes hidden state (information from previous inputs) + input into tanh activation function which outputs between -1 and 1
- Then, it all comes together!!!!!
  - Sigmoid output * tanh output
    - Sigmoid function determines what is worth to keep in the tanh output

#### Forget Gate + Input Gate together
- Cell state * Forget vector (more checking if cell state content should get dropped)
- Take this^ value and do pointwise addition with input gate output
  - Updates cell state to new values (Gives new cell state)

#### Output Gate
- Decides what next hidden state should be
- Pass [hidden state + input] into sigmoid
- Pass newly modified cell state into tanh 
- Multiply sigmoid output with tanh output to see what hidden state should keep
- Output is the hidden state

#### OVERALL FLOW: 
1. Combine hidden state and input into a vector 
2. Feed this into forget gate which has a sigmoid function 3. Info is either dropped or kept depending on if output of sigmoid is 0 or 1 
4. Vector is now passed to input gate's sigmoid function (outputs 0 or 1)
5. Vector is also passed to input gate's tanh function (outputs 0 or -1) 
6. Multiply these two results to determine if the information should be kept or not
7. Cell State and vector are multiplied 
8. This ^ value and input gate output are pointwise added to update cell state to new values 
9. Pass the vector into the output gate's sigmoid 
10. Pass newly modified cell state into output gate's tanh 11. Multiply both these outputs to see what hidden state should be kept 
12. Output gate outputs the new hidden state which will be passed into the network once again

**Note to help remember this**: Sigmoid is always used to determine what is dropped or forgotten









