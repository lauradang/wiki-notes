# Linear Algebra Proofs Guide

## General Proofs Help Table

| **What you are trying to prove** | What to use when specific theorems fail |
| -------------------------------- | --------------------------------------- |
| $$A\le B$$                       | Prove A is a subset of B                |
|                                  |                                         |
|                                  |                                         |

## 7.1 Fundamental Subspaces

| Concepts    | Representations                                              |
| ----------- | ------------------------------------------------------------ |
| $$Col(A)$$  | Let $$\vec{x} \in Col(A)$$ and $$ \vec{r_1}, ... \vec{r_m}=rows \space in \space A$$. <br />$$\vec{x}=c_1\vec{r_1}+...+c_m\vec{r_m}$$ |
| $$Null(A)$$ | Let $$\vec{x} \in Null(A)$$ and $$ \vec{r_1}, ... \vec{r_m}=rows \space in \space A$$. <br />$$\vec{0}=\begin{bmatrix}\vec{r_1}\vec{x}\\\vdots\\\vec{r_m}\vec{x}\end{bmatrix}$$ |

### Extensions from Theorems

**Theorem 7.1.5**: $$rank(A)=rank(A^T)$$ 

$$\Rightarrow Col(A)=Row(A^T), Row(A)=Col(A^T)$$

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
| $$rank(M \circ L) \le rank (M)$$ | Prove that the $$Range(M \circ L)$$  is a subset of $$Range(M)$$<br />- Can only use this if both ranges are in the same subspace |
| $$rank(M \circ L) \le rank (L)$$ | Since they are not in the same subspace, we cannot use the above strategy<br />Instead, analyze kernels and use rank-nullity theorem.<br />$$\Rightarrow$$ Prove that $$ker(M \circ L) \ge ker(L)$$, then use rank-nullity theorem to do the rest |

When you are given information about **rank**, try to turn it into information about **nullity** instead since you can generally do more with kernals then range.

## 8.3 Matrix of a Linear Mapping

**Solving for $$[\vec{x}_B]$$**: 

- $$\vec{x}=c_1\vec{B_1}+c_2\vec{B_2}...$$ Solve for $$c_1, c_2, ...$$
  - If $$\vec{x}$$ is a polynomial, collect like terms on the RHS if $$\vec{x}$$ is in the form $$a+b\vec{x}+...$$ This way we can do coefficient equality in order to solve for the coefficients (pg. 226 example)

**Solving for $$[L(\vec{v})]_C$$**

- $$L(\vec{v})=c_1C_1+...$$ Solve for $$c_1, ...$$

## 8.4 Isomorphisms

| Assumptions/Information      | Interpretations/Applicable Theorems                          |
| ---------------------------- | ------------------------------------------------------------ |
| $$V$$ is isomorphic to $$W$$ | 1. There exists $$L: V \rightarrow W$$ that is linear mapping.<br />2. L is 1-1 and onto $$\Rightarrow$$ $$Range(L)=W$$ and $$Ker(L)=\{\vec{0}\}$$ |

| **What you are trying to prove** | What to use                                                  |
| -------------------------------- | ------------------------------------------------------------ |
| $$V$$ is isomorphic to $$W$$     | 1. Define a basis for $$V$$ and a basis for $$W$$<br />2. Define mapping $$L: V \rightarrow W$$ that maps the basis for $$V$$ to the basis for $$W$$<br />e.g. $$V=\{ \vec{v_1},...\vec{v_2}\}$$, $$W=\{ \vec{w_1},...\vec{w_2}\}$$<br />$$L(t_1\vec{v_1}+...+t_n\vec{v_n})=t_1\vec{w_1}+...+t_n\vec{w_n}$$<br />3. Prove that the mapping is linear, 1-1, and onto. |
| $$L$$ is injective               | Prove that $$ker(L)=\{\vec{0}\}$$                            |







I'm a bit confused on how to prove that $$Q_{k,n}$$ 









