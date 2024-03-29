# Lecture 7

### References Continued
```C++
int y = 10;
int &z = y;
```
**Things you cannot do without references**:
ACRYNOM: UVPRA
- leave uninitialized X ```int &x;```
  - Must be initialized to **lvalue** (left value)
    - values can occur on left side of assignment
- data with a permanent address (on stack or heap)
  - variables:
    - int &x = y; (works)
    - int &x = 3; (does not work)
      - 3 in itself does not have a memory address, when it is x=3 however, then x is stored in a place in memory and it has 3 in it
    - int &x = y + z; (does not work)
- create pointer to a reference
  - int &*x; (does not work)
- create a reference to a reference
  - eg. int &&a=z; (does not work)
    - && means something else which you will see later
- create an array of references
  - eg. int &r[3]={y, y, y}; (does not work)

**What are references useful for?**
- Passing parameters to functions
  - in general, better to pass by reference
  - then, decide if const based on use of parameter

**Example:**
```C++
// Copy of value of parameter is used in f
int f(int x) {....}

struct Really Big {int arr[1000000];};

// Copies could be slow
int f(Really Big rb) {...}; 

// Making an alias (faster) - does not make a copy
// Passing by reference
// Can change rb
int g(ReallyBig &rb) {...}; 

// Making an alias (faster) - does not make a copy
// Cannot change rb
int h(const Really Big &rb) {...};
```
### Dynamic Memory Allocation
**Example in C:**
```C
int *p = malloc(numberofElems*(sizeof(int)));
...
free(p);
```

**C++**:
- use new/delete -> type-aware, less error prone

**Example in C++:**
```C++
struct Node {
  int n;
  Node* next;
}

Node* np = new Node;
Node* np2 = new Node{5, nullptr};

// To deallocate:
delete np;
```
- New returns an address on the heap
  - initializes if we give it information 


**Array Forms**
```C++
Node *myNodes = new Node[20];

delete [] myNodes;
```

### Returning by Value/Pointer/Reference
```C++
// copies Node that is here, copy it into stack that it is being returned to
Node getMeANode(){
  Node n;
  return n;
}
```
- copies node in function into the stack of the calling function
- could be expensuve due to making a copy

**Return by pointer/reference**
```C++
Node* getMeANode() {
  Node n;
  return &n;
}
```
- Not a good idea
- Return address in stack frame of the function
- var goes out of scope and is deallocated -> dangling pointer

```C++
Node* getMeANode() {
  Node* np = new Node;
  return np;
}
```
- np is in the stack of the function
  - np is pointing at heap data
- np goes out of scope but doesn't allocate the memory it is pointing at
- calling function needs to delete Node

### Operator Overloading
```C++
string s = "hello", t=" world";
string r = s+t;
int n = 7, m = 5;
int a = n + m;
string r = s + t;
calls string operator + (const string &s, const string &t);

int a = n + m;
calls int operator + (const int &x, const int &y)
```

```C++
struct Vec {
  int x,y;
};

Vec operator+(const Vec &v1, const+Vec&v2){
  Vec v {v1.x + v2.x, v1.y + v2.y}
  return v;
}
Vec x = z + y;

Vec operator *(const int k, const Vec &v){
  return {k*v.x, k*v.y}
}

// compiler initialized based on return type of function

Vec& operator += (Vec &v1, const Vec &v2){
  v1.x += v2.x;
  v1.y += v2.y;
  return v1;
}

Vec x = 2*v;

Vec operator = (const Vec &v, const int k){
  return k*v;
}

// calling the other operator* ensures the two are equivalent
```
### Overloading ```<<``` and ```>>```
```C++
struct Grade {
  int theGrade;
};
ostream& operator <<(ostream& out, const Grade&g){
  out << g.theGrade << "%";
  return out;
}

Grade g {78};
cout << g << endl; // 78%

istream& operator >>(istream& in, Grade &g){
  in >> g.theGrade;
  if (g.theGrade < 0) g.theGrade = 0;
  if (g.theGrade > 100) g.theGrade = 100;
  return in;
}
```

### The Preprocessor
- Transforms program before compiler sees it 
- preprocessor directive - #________
  - eg. #include
  - eg. #define VAR VALUE









