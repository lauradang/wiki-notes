# Lecture 11

### Copy Assignment Operator
**EXAMPLE**:
```C++
Student billy {...};
Student bobby {billy}; /// copy ctor
Student jane;
jane = billy; // copy assignment
jane.operator = (billy);

n1=n2; // n1.operator=(n2);
n1=n2=n3; // n2.operator = (n3);
```

**EXAMPLE**:
```C++
Node & Node::operator=(const Node &other) {
  if (this==&other) return *this; // self assignment check
  data = other.data;
  
  delete next; // since we are updating on existing obj
  
  next = other.next? new Node {*other.next}=nullptr;
  return *this;
}
```
- If new fails, stop executing
  - next is a "dangling pointer"
  
**New assignment operator:**
```C++
Node &Node::operator=(const Node &other) {
  if (this==&other) return *this;
  Node *temp=next;
  next = other.next? new Node {*other.next}=nullptr;
  data = other.data;
  delete temp;
  return *this;
}
// Switch of order; keeping temp in class
// Assign new, then delete
```

### Copy and Swap Idiom
```C++
struct Node {
  void swap(Node &);
  Node &operator = (const Node &);
};

#include <utility>
  void Node::swap(Node &other) {
  swap(data, other.data);
  swap(next, other.next);
}

Node &Node: operator=(const Node &other) {
  Node temp{other};
  this->swap(temp); // automatically deleted after shifting out of scope
  return *this;
} // requires correct dtor
```

**EXAMPLE**: Classes/vvalue/node.cc

```C++
// 2 copy constructors for 2 nodes
Node plusOne (Node n) {
  return n;
}

// 2 calls to constructor
Node n {1, new Node {2, nullptr}};
Node n1 {plusOne(n)}; 
```

**Note**: we would like 2 kinds of constructors:
1. One that copies from non-temp object (copy ctor) (lvalue reference)
2. One that steals from a temp obj are r-values (rvalue reference)

**Rvalue Reference**: Reference to a temporary
Node <- Node
Node & <- lvalue
Node && <- rvalue reference

### Move Constructor

```C++
Node::Node(Node &other):
  data {other.data},
  next {other.next} {
    other.next = nullptr;
  }
  
n1 = plusOne(n); //temp rvalue
n1 = n2; //lvalue
```

### Move Assignment Operator
```C++
Node &Node::operator=(Node &&other) {
  swap(other);
  return *this;
}
// Copy/move elision
```























