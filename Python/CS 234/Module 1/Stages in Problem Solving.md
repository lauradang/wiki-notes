# Stages in Problem Solving

User and provider knows their roles now. Work needs to be broken into two stages: **Planning, Coding**

## Planning

- Done before programming (no computer)
- Understand possible options for ADTs

### Model of Computation

- Modelling how they intend to implement and use ADTs
- **Pseudocode**: high level approach describing algorithms and implementation without considering language or machine of code (no need to consider language-specific features and requirements yet)

### Memory Model

- Simplified interpretation of how data will be stored in computer memory and how it will be managed by ADT
- Provider is concerned with this during planning

## Planning by the User

- Simplified interpretation of how data will be stored in computer memory and how it will be managed by ADT
  - What operations  (add, remove, search, etc.)?
  - What type of data is being stored (int, float, string, etc.)?
  - Will there be limits to the data being stored?
  - These questions will help to choose appropriate ADT for their task

- Should write psuedocode on how ADT is being used - helps to see what operations are needed
  - Calculate cost of algo in terms of ADT operations

## Planning by the Provider

- Figures out how to **store, access, modify** data used by **ADT operations**
  - What implementations can be used to store data?
  - What algorithms can be used for the operations (also considering cost)?
- **Data structure**: An implementation the specifies how to store data in computer's memory
  - Used to implement ADT, algorithm of ADT's operations depends on data structure
- **Algorithm**: Sequence of steps
- **Provider's goal**: Present multiple options to users (different data structures and algorithms)
  - Considerations for ADT include: 
    - space required for ADT
    - operation runtimes
  - Writes pseudocode and calculates runtimes for operations

**Note**: ADT vs. Data structure - ADT is what operations and what structure we want, but does not look at specific memory structure (that is for data structures)

## Summary for Planning Process

First, user and provider must have an **agreement on ADT**. Then work can be split.

|      | User                                                         | Provider                                                     |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Plan | Pseudocode using ADT, *data structure and algorithms unknown* | Pseudocode for data structure and operations, *ADT use unknown* |

Second, user and provider must have an **agreement on code interface**. Then work can be split.

|      | User                                                    | Provider                                                  |
| ---- | ------------------------------------------------------- | --------------------------------------------------------- |
| Code | Code using ADT, *data structure and algorithms unknown* | Code for data structure and operations, *ADT use unknown* |



## Planning Recipe

### User/Plan (Solving problem) Recipe:

1. Determine data types and operations
2. For each type, choose/modify/create ADT
3. Developer pseudocode algo using ADT operations
4. Calculate algo cost with respect to operations cost
5. Using info from provider, choose best option

### Provider/Plan Recipe:

1. Create pseudocode of various options for data structures and algos to implement ADT and its operations
2. Analyze cost of each operation per implementation
3. Provide options for packages of operation costs

## Coding

- Best ADT option is determined
- **Code interface**: Describes how to interact with the ADT
  - Includes operations of ADT (parameters, returned values, preconditions, postconditions)
- Both user and provider write their pseudocode in chosen programming language
- Module for ADT imported into user's code

## Coding Recipe

This is done after user and provider agree on code implementation.

### User/code Recipe: 

- Code solution to problem using ADT

### Provider/code Recipe:

- Code chosen data structure and algos implementing ADT

### 