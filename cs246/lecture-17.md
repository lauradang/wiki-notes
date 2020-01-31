# Lecture 17

## Templates

* Class parametrized by a type
* Used to store other things - like new classes
* Put implementation in `.h` files

**Consider the linked list implementation:**

```cpp
class Node {
    int data;
    Node *next;
    public:
        Node(int data, Node *next): data(data), next(next) {}
        ~Node() { delete next; }
        int getData() { return data; }
        Node *getNode() { return next; }
};

int main() {
    Node *ll = new Node(1, new Node(2, 0));
    // ...
    delete ll;
}
```

**Limitations of this implementation**: Can only hold a list of ints **How to improve this implementation**: If we want to store other types, must use `void *` pointers or **templates**

**Consider the linked list implementation with TEMPLATES:**

```cpp
template<typename T> class Node {
    T data; // this data is of type `T`
    Node<T> *next; // `Node<T>` refers to this class parameterized over the same type
    public:
        Node(T data, Node<T> *next): data(data), next(next) {}
        ~Node() { delete next; }
        T getData() { return data; }
        Node<T> *getNode() { return next; }
}

int main() {
    Node<char> *ll = new Node<char>('a', new Node<char>('b', 0))
    // `ll` is a linked list of characters
    // ...
    delete ll;
}
```

* Allows us to declare that the following is parameterized over the type`T`. So inside the part that follows,`T`refers to a typename that we can specify in our client code.
* The `Node<SOME_TYPE_GOES_HERE>`is a **template specialization**
* **Name of the class is still Node, but we still need to write**  when it is ambiguous what type T might be
* Allows us to have a linked list of whatever type we want.
* When encountering a template specialization like Node, **compiler creates in memory a new class identical to Node with T replaced with the actual type** \(similar to the preprocessor, but more powerful, and also typesafe\)
  * i.e. Compilier specializes templates at the source code level, before compilation.

**Note**: We can even do `Node< Node<int> >` or even more nested structures. But, note that `Node<Node<int>>` doesn't compile because `>>` is a right shift operator, so we need to add a space.

**In-Class Template Example**:

```cpp
 template <typename T> class List {
  struct Node {
    T data;
    Node *next;
   };

   Node *therList;

   public:
    class Iterator {
      Node *p;
      explicit Iterator (Node *p): p{p} {}

      public:
        T &operator*() {
          return p->data;
        }
    };

  T &ith (int i) {...}
  void addToFront (T x) {...}
  };

  // Client
  List <int> l1;
  List <List<int>> l2;
  l1.addToFront(3);
  l2.addToFront(l1);

  for (List<int)::Iterator it.l1.begin(); it != l1.end(); ++it) {
    cout << *it << endl;
  }

  for (auto n: l1) {
    ...
  }
```

## The Standard Template Library \(STL\)

* Has a large \# of useful templates

  eg. dynamic-length arrays:  \`\`\`vector

### Vector Operations

```cpp
#include <vector>
using namespace std;

vector<int> v {4, 5}; // creates vector 4 5
v.emplace_back(6); // 4 5 6
v.emplace_back(7) // 4 5 6 7

// Note:
vector<int> v(4,5); // only case in course where round bracket and curly bracket initialization are different
// the above code produces 5 5 5 5 instead of 4 5

// Looping vector with no range check
for (int i=0; i < v.size(); ++i) {
  cout << v[i] << endl;
}

// array access with range checking (impossible to get out of bounds error)
for (int i = 0; i < v.size(); ++i) {
  std::cout << v.at(i) << std::endl; 
}

// RECOMMENDED WAY OF ITERATING
for (vector<int>::iterator it = begin(); it != v.endl(); ++it) {
  cout << *it << endl;
} // note here that it's iterator not Iterator

// the above code can of course be replaced by auto
for (auto n:v) {...}

// Iterating in reverse
for (vector<int>::reverse_iterator it = v.rbegin(); it != v.rend(); ++it) 

v.pop_back() // removes last element

// Use iterators to remove items from inside a vector:
auto it = v.erase(v.begin()); // erases the first item
it = v.erase(v.begin() + 3); // erases the 4th item, returns iterator pointing to first item after the erase

it = erase(it); 
v,erase(v.end()-1) // last item
```

### Indexing

* the `v[i]` is the ith element of v
* Going out of bounds is **undefined behaviour**
* Use `v.at(i)` 
  * Checked version of `v[i]`
  * So what happens when you go out of bounds?
  * What should happen? \(Raise an Exception\)

**Problem:**

* vector's code can detect the error, but doesn't know what to do about it
* client can respond, but can't detect the error

**C Solution**: functions return a status code or set the global variable **errno**

* leads to awkward programming
* encourages programmers to ignore error-checks

**C++ Solution**: when error arises, the function raises an **exception** What happens? By default, execution stops

## Exception \(Try and Catch\)

But we can write handlers to catch extensions to deal with out of bounds. .`vector<T>::at` throws `std::out_of_range` when it fails. We can handle is as follows:

```cpp
#include <stdexcept>
...
try {
  cout << v.at(10000);
} catch (out_of_range r) {
  cerr << "Range error: " << r.what() << endl;
}

// execution resumes here
```

### Stack Unwinding

**Consider the following**:

```cpp
void f() {
  throw out_of_range {"f"}; // ctor argument = what
}

void g() {
  f();
}

void h() {
  g();
}

int main() {
  try {
    h();
  } catch (out_of_range) {...} // r does not have to be here
}
```

**What happens in the above code?** 1. main calls h 2. h calls g 3. g calls f 4. f raises out\_of\_range 5. Control goes back through the call chain \(_unwinds_ the stack\) until **handler** \(the catch\) is found, in this case, back to main \(where main handles exception\)

If there is matching handler in the entire call chain =&gt; program terminates

A handler might do part of the recovery job, i.e. execute some corrective code and throw another exception.

```cpp
try {...}
catch (SomeErrorType s) {
  ...
  throw SomeOtherError {...};
}

// or rethrow the same exception:
try {...}
catch (SomeErrorType s) {
  ...
  throw;
}
```

### Throw

**`throw; vs. throw s {...};` \(from code above\)**:

.`throw s {...};`

* s may be a subtype of SomeErrorType
* throws a new exception of type SomeErrorType

.`throw;`

* actual type of s is retained

**In the end, it's better to just say throw;**

#### Catching all Errors

A handler can act as a catch-all

```cpp
try {...}
catch (...) { // catches all exceptions (it's actually "..." in the brackets after catch)
  ... 
}
```

**Note:** You can throw anything you want - Don't always have to throw objects

#### Never let a destuctor throw an exception

**Why not?**

* Program will abort immediately **\(defined behaviour\)** 
* If you want a destructor to throw, then tag it with `noexcept(false)`
* But - if a destructor is running during stack unwinding, while dealing with another exception and it throws, you now have 2 active unhandled exceptions and the program will abort immediately

