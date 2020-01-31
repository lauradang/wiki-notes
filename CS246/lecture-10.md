# Lecture 10

**Note**: Careful with constructors that can take one param
```C++
struct Node {
  ...
  Node (int data):
    data{data}, next{nullptr};
}
```
- single-arg constructors create implicit conversions
eg. ```Node n{4}```
- but also ```Node n=4;``` 
  - implicit concersion from int to Node
```C++
int f(Node n);
f(4); // works - 4 implicitly converted to Node

Node m{4}; // works fine
Node m = 4; // works - but 4 is not a node, it is an int 
```
***DANGER***: 
- accidentally passing an int to a function expecting a Node
  - silent conversion
  - compiler does not signal an error
  - potential errors are not caught

***How to fix***
- Disable the implicit conversion - make constructor explicit
```C++
struct Node {
  ...
  explicit Node (int data): data{data}, next{nullptr} {}
}

Node n{4}; // OK!
Node n=4; // not allowed
f(4); // not allowed

f(Node {4}); // OK!
```

### Destructors
When an object is destroyed:
- stack-allocatd: goes out of scope
- heap-allocated: is deleted
- A method called the **desctructor** is run
- Classes come with a destructor (just calls destructors for all fields that are objects)

**What happens when an object is destroyed?**
1. destructor body runs
2. fields' destructors are invoked in reverse declaration order (for fields that are objects)
3. space deallocated

**When do we need to write a destructor?**
```C++
Node *np=new Node {1, new Node {2, new Node {3, nullptr}}};
```
If np goes out of scope 
- pointer np is reclaimed (stack-allocated)
- the list is leaked

If we say ```delete np;```:

**Write a destructor to ensure the whole list is freed:**
```C++
struct Node {
  ...
  ~Node() {
    delete next;
  }
}
```
Now - delete np; frees the whole list
- invokes *next's destructors using recursion
- therefore, the whole list is deallocated

### Copy Assignment Operator
```C++
Student billy {60,70,80};
Student jane=billy; // copy constructor

Student joey; // default constructor
joey = billy; // copy, but not a construction, it is the copy assignment operator -uses compiler-supplied default
```
- You may need to write your own copy assignment operator:
```C++
// WRONG AND DANGEROUS WAY:
struct Node {
  ...
  // so that cascading works (eg. a=b=c=d;)
  Node &operator = (const Node &other) {
    data = other.data;
    next=other.next?new Node{*other.next*}:nullptr;
    return *this;
  }
}
```
**Why is this way dangerous?**
```C++
Node n {1, new Node {2, new Node {3, nullptr}}};

// deletes n and then tries to copy n to n
// undefined behaviour
n=n; 
```
When writing operator=, always watch out for self-assignment:
```C++
struct Node {
  ...
  Node &operator=(const Node &other) {
    if (this == &other) return *this;
    data = other.data;
    delete next;
    
    // if "new" fails, this method will abort
    // next has been deleted, but not reassigned, therefore we have pointers at dead memory which means we have a corrupted list
    next = other.next? new Node {*other, next}: nullptr;
    return *this;
  }
}
```
**Better Way:**
```C++
Node &Node::operator=(const Node &other) {
  if (this == &other) return *this;
  Node *tmp = next;
  next = other.next? new Node {*other.next}:nullptr;
  data = other.data
  delete tmp;
  return *this; // if new fails, node will still be in its original state (not corrupted)
}
```
**Note**:
```C++
*other.next // equivalent to *(other.next)
other->next // equivalent to (*other).next
```

### Alternative: copy-and-swap idiom

```C++
#include <utility>

struct Node {
  ...
  void swap (Node &other) {
    using std::swap;
    swap(data, other.data);
    swap(next, other.next);
  }

  Node &operator = (const Node &other) {
    Node tmp = other;
    swap(tmp);
    return *this;
  }
};
```

### Rvalues and Rvalue references
**Recall**:
- an lvalue is anything with an address
- an lvalue ref (&) is like a const pointer with auto-deret
  - always initialized to an lvalue

**Now consider**:
```C++
Node plusOne (Node n) {
  for (Node *p=&n; p; p=p->next) {
    ++p->data;
  }
  return n;
}

Node n {1, new Node {2, nullptr}};
Node n2 = plusOne(n); //copy construction
```
- compiler creates a temporary object to hold the result of plusOne
- other is a reference to this temporary
  - copy constructor deep-copies from this tmeporary

But
- 























