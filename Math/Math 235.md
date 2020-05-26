# Linear Algebra Proofs Guide

## General Proofs Help Table

| **What you are trying to prove** | What to use when specific theorems fail |
| -------------------------------- | --------------------------------------- |
| $$A\le B$$                       | Prove A is a subset of B                |
|                                  |                                         |
|                                  |                                         |

## 8.2 Linear Mappings

### Inventing/Finding linear mappings

Common $$V$$ and $$W$$ vector spaces to use:

| Vector Space    | Dimension                                    |
| --------------- | -------------------------------------------- |
| $$P_2(\R)$$     | # of $$x^n$$ terms e.g. $$dim(a+bx+cx^2)=3$$ |
| $$M_{2x2}(\R)$$ | 4                                            |
| $$\R^n$$        | n                                            |

Practice: pg. 224 q3,4

### Proofs Help

| Definitions                                                  | Assumptions/Information                           | Interpretations/Applicable Theorems                          |
| ------------------------------------------------------------ | ------------------------------------------------- | ------------------------------------------------------------ |
| $$L: V\rightarrow W$$ is linear mapping                      | $$\{L(\vec{v_1}), ...L(\vec{v_k})\}$$ spans $$W$$ | $$Range(L)=W$$, $$dim(Range(L))=k=rank(L)$$                  |
| $$L: V\rightarrow W$$ is linear mapping                      |                                                   | $$dim(V)=n$$<br />$$rank(L)=dim(Range(L))$$                  |
| $$L: V\rightarrow W$$ is linear mapping                      | $$Ker(L)=\{\vec{0}\}$$                            | $$dim(Ker(L))=0=nullity(L)$$                                 |
| $$L: U\rightarrow V$$ is linear mapping<br />$$M: V\rightarrow W$$ is linear mapping | $$Range(M \circ L)$$                              | Let $$\vec{x}\in Range(M\circ L)$$. <br />Then there exists $$\vec{v}\in V$$ where $$\vec{x}=(M\circ L)(\vec{v})=M(L(\vec{v}))\in Range(M)$$.<br />Therefore $$Range(M \circ L)$$ is a subset of $$Range(M)$$ |

| **What you are trying to prove** | What to use                                                  |
| -------------------------------- | ------------------------------------------------------------ |
| $$dim V \le dim W$$              | 1. Rank nullity theorem<br />2. Prove that V is a subset of the W |
| $$rank(M \circ L) \le rank (M)$$ | Prove that the $$Range(M \circ L)$$  is a subset of $$Range(M)$$ |
| $$rank(M \circ L) \le rank (L)$$ |                                                              |

