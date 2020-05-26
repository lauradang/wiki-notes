# Roles in Problems

## User and Provider

This course will consider two roles when splitting work: **Provider, User**.

**Examples**:

|          |                                                              | Description                                                  |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| User     | Car buyer                                                    | Decide what parts are needed, specify functionality          |
| Provider | Car sales person                                             | Agrees on contract for both user & provider, provides part that satisfies functionality requirements |
|          |                                                              |                                                              |
| User     | Individual using implemented data structure                  | Does not know how ADT is implemented                         |
| Provider | Individual responsible for designing and implementing data structure | Does not know how ADT is used                                |

## Splitting Work with ADTs

### Abstract Data Type (ADT)

- Combination of data and operations that can be performed on data
- Does not specify implementation or how data is stored
- User and provider must agree on the ADT

e.g. List - operations include insert, remove, search, access

### Modularity

- Division of program into independent, reusable pieces
- Implementation is not specific - can be generalized for many tasks
- e.g. Python Math library - User does not need to undersatnd implementation and can be imported in any program

### Data Hiding

- Protection of data from other parts of progam
- Forbid *directly* accessing fields of a class to user (only use methods to access data)

### Preconditions and Postconditions

- Some operations require/guarantee the data to be in a specific state
- e.g. Removing element from list requires an item to exist in the list (precondition) - a requirement
- e.g. After removing element, len(list) decreases by 1 (postcondition) - a guarantee

## 