# Lecture 13

**Recall:**

* encapsulated list class
* can't traverse the list node-to-node
* repeatedly calling ith =&gt; O\(n2\) time

### SE Topic: Design Patterns

* certain programming problems arise often
* keep track of good solutions to these problems reuse and adapt them
  * If you have this problem, then this technique may solve it
  * **Our problem:** traversing a list without resulting in O\(n2\) time while keeping nodes secure 
  * **Solution:** Iterator Pattern

### Iterator Pattern

* Create a class that manages access to nodes
* Abstraction of a pointer
* Walk the list without exposing the actual pointers

Iterating through an array in C-style

```cpp
for (int *p = arr; p < arr + size; ++p) {
  cout << *p << endl;
}
```

* Want class that acts as pointer p

```cpp
class List {
  struct Node;
  Node *theList;

  public:
    class Iterator {
      Node *p; // think of pointer as your bookmark (where am I in the array)
      public:
        explicit Iterator (Node *p): p{p}{}
        Iterator &operator++() {
          p = p->next; 
          return *this;
        } 

        int &operator*() {
          return p->data;
        } // O(1)

        bool operator!= (const Iterator &other) {
          return p != other.p;
        } // O(1)
    };

    Iterator begin() {
      return Iterator{theList};
    } // O(1)

    Iterator end() { // O(1)
      return Iterator{nullptr;}
    }
}
```

Now what does client's code look like?

```cpp
int main() {
  List l;
  l.addToFront(1);
  l.addToFront(2);
  l.addToFront(3);

  for (List::Iterator it=l.begin(); it != l.end(); ++it) { 
    cout << *it << endl;
  } // Now this runs in O(n) time instead of O(n^2)
}
```

Shortcut: automatic type deduction

### Automatic Type Deduction

```cpp
// gives x the same type as the value of y
auto x = y;
```

Applying the shortcut:

```cpp
for (auto its=l.begin(); l != l.endl(); ++it) {
  cout << *it << endl;
}
```

An even shorter shortcut:

```cpp
// bi-value declaration: n is a copy of the list item
for (auto n:l) {
  cout << n << endl;
}

// If you want to modify list items or save copy
for (auto &n:l) {
  ++n;
}

// OR
for (const auto &n:l) {
  ...
}
```

### Range Loops

* available for any class with:
  * methods `begin` and `end` that produce iterators
  * the iterator must support `!=`, prefix `++`, unary `*`

## Encapsulation continued

### Encapsulation with Constructors

* List client can create iterators directly by doing:

  ```cpp
  auto it = List::Iterator {nullptr};
  ```

* Violates encapsulation 
  * client should be using end\(\)
* We could make Iterator's constructor private, but two problems arise:
  1. Client cannot call `List::Iterator`
  2. List cannot call `Iterator`

**Problem:** How do we allow client to create iterators without breaking encapsulation? **Solution:** Make `List` a _friend_ of `Iterator`

### Friends

* Gives class privileged access to another class

**Solution explained:**

* Make List a _friend_
  * give List privileged access to Iterator by making List a _friend_
* So now List can still create iterators, but client can only create iterators by calling begin/end

```cpp
class List {
  ...
  public:
    class Iterator {
      Node *p;
      explicit Iterator(Node *p);
    public:
      ...
      friend class List; // List has access to all members of Iterator
    };
  ...
};
```

**Rule of Thumb with Friends**: Give your classes as few friends as possible - weakens encapsulation

### Accessor/Mutator Methods

* Provides access to private fields

  ```cpp
  class Vec {
  int x,y;
  public:
    ...
    int getX() const { // accessor
      return x;
    } 
    void getY(int z) { // mutator
      y=z;
    }
  };
  ```

  **Why not just put int x and y in public?**

* advantage to this is if you want x and y to have certain restrictions, but not complete restriction 

#### Dealing with private fields for the`operator<<`?

* operator&lt;&lt; needs to access x and y fields, but the operator function cannot be a member \(needs to be outside the class\)
* We have two options in this case:
  1. if `getX`, `getY` defined, then use these methods to access x and y
  2. if you don't want to provide getX and getY - make `operator<<` a friend function:

```cpp
// .h
class Vec {
  ...
  friend std::ostream &operator<< (std::ostream &out, const Vec &v);
// not a member function, this is a friend declaration (still has two arguments, one of them do not become this)
}

// .c
ostream &operator<<(ostream &out, const Vec &v) {
  return out << v.x << ' ' << v.y;
}
```

## System Modelling \(UML\)

* Visualizing the structure of the system \(abstractions and relationships among them\) to aid design and implementation

  Popular Standard: **UML** \(Unified Modelling Language\)

### Modeling Classes

| **Name** | **\*\*Vec** |
| :--- | :--- |
| Fields \(optional\) | -x: Integer, -y: integer |
| Methods \(optional\) | +getX: Integer, +getY: Integer |

\*\*Visibility: - means private, + means public, \# means protected

### Relationship: Composition of classes

```cpp
class Vec {
  int x,y,z;
  public:
    Vec(int, int, int);
};

// Two vecs define a plane:
class Plane {
  Vec v1, v2;
  ...
};

// This does not compile
Plane p; // can't initialize v1 and v2 without help - no default constructor for vec

class Plane {
  Vec v1, v2;
  public:
    // means initialize v1 to Vec {1,0,0};
    Plane(): v1{1,0,0}, v2{0,1,0}, v3{0,0,1} {} 
    ...
}
```

### Composition \(OWNS-A\)

* Embedding an object inside another

**Example:**

* Embedding Vec inside Plane is called composition.

**Relationship shown in example:**

* A Plane **OWNS-A** Vec \(Owns 2 of them\)
* If A **OWNS-A** B, then typically: B has no identity outside A \(no independent existence\)
  * If A is destroyed, B is destroyed
  * If A is copied, B is copied \(deep copy\)
* eg. A car owns four wheels - a wheel is part of a car
  * destroy the car =&gt; destroy the wheels
  * copy the car =&gt; copy the wheels
* **Typical Implemention:** typically as composition of classes
* Modelling: Plane

#### UML

![](https://github.com/lauradang/wiki/tree/02eb402295150315a637b01bda9543b0bd4c7d13/Users/lauradang/Desktop/CS246/UMLs/composition.jpg)

