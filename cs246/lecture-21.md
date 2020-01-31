# Lecture 21

## Measures of Design Quality

* compiling and cohesion

**Note**: You want to balance between cohesion and coupling \(if you have perfect coupling, that means all modules are in the same file, which isn't right\)

### Coupling

* How much distinct modules depend on each other
* **Low** coupling:
  * modules communicate via function calls basic params/results
  * modules pass arrays/struct back and forth
  * modules affect each other's control flow
* **High** coupling:
  * modules have access to each other's implementation \(friends\)
  * implies changes to one module require changes to other modules
  * makes reuse hard

### Cohesion

* How closely elements of a module are related to each other
* **Low** cohesion:
  * Arbitrary grouping of unrelated elements \(eg. `<utility>`\)
  * Elements share a common theme, otherwise unrelated, maybe share some base code \(eg. `<algorithm>`\)
  * Elements manipulate state over the lifetime of an object
    * eg. Open/read/close files
  * Elements pass data to each other
  * Poorly organized code
  * hard to understand, maintain, reuse
* **High** cohesion
  * Elements cooperate to perform exactly one task

**Goal: LOW COUPLING, HIGH COHESION**

## Decoupling the Interface \(MVC\)

Your primary program classes should not be printing things. **Example**:

```cpp
class Chessboard {
  cout << "Your move" << endl;
}
```

* Bad design - inhibits code reuse

What if you want to reuse the chessboard, but not have it communicate via stdout?

You could: 1. Give the class stream objects, where it can send its input/output

```cpp
class Chessboard {
  istream &in;
  ostream &out;
  ...
  out << "Your move" << endl;
}
```

* Better - but what if we don't want to use streams at all? Your chessboard should not be doing any communication at all

## Single Responsibility Principle

_**A class should have only one reason to change.**_

* game state and communication are **two** reasons

Better:

* Communicate with the chessboard via params/results
* Comtinue user communication to outside the game class

**Question**: Should main do the talking? **Answer**: No - hard to reuse code if it is in main Should have a class to manage interaction, separate from the game state class.

**Architecture**: Model-View-Controller \(MVC\)

## Model-View-Controller \(MVC\)

* separate the distinct notions of the data \(or state - "model"\), the presentation of the data \("view"\), and the control or manipulation of the data \("controller"\)
* Decouples presentation and control =&gt; promotes reuse

#### Model

* can have multiple views \(eg. text/graphics\)
* doesn't need to know their details
* class Observer pattern \(or could communicate through controller\)

#### Controller

* mediates control flow between model and view
* might handle input \(or could be the view\)

## Exception Safety

Consider the following:

```cpp
void f() {
  MyClass mc;
  MyClass xp = new MyClass;
  g();
  delete p;
}
```

No leaks, but what if g throws? What is guaranteed?

* During stack-unwinding, all stack-allocated data is cleaned up
* Destructors run, memory reclaimed
* Heap-allocated objects NOT destroyed

Therefore, the line delete p; does not occur, and \*p is leaked.

```cpp
void f() {
  MyClass mc;
  MyClass *p = new MyClass;
  try {
    g();
  } catch (...) {
    delete p;
    throw;
  }
  delete p;
}
```

* Duplication of code occurs here
* How else can we guarantee that something \(eg. delete p\) will not happen no matter how we exit f? \(normal or exception?\)

In some languages, there are "finally" clauses that guarantee certain final actions

**Only thing you can count on in C++:** Destructors for stack-allocated data will run

* Therefore use stack-allocated data with destructors as much as possible
* use the guarantee to your advantage

**C++ idiom:** RAII \(Resource Acquisition Is Initialization\)

## RAII \(Resource Acquisition Is Initialization\)

Every resource should be wrapped in a stack-allocated object whose job is to delete it **Example**:

```cpp
// files
{
  // In the following ling, acquiring the resource ("file") is initializing the object
  ifstream f{"file"};
  ...
  // the file is guaranteed to be released when f is popped from the stack (f's destructor runs)
}
```

This can be done with dynamic memory:

```cpp
#include <memory>
class std::unique_ptr<T>
```

* takes a T\* in the constructor
* the destructor will delete the pointer
* in between - can dereference, just like a pointer

THIS IS THE FINAL SOLUTION:

```cpp
void f() {
  MyClass mc;
  std::unique_ptr<MyClass> p {new MyClass};
  g(); // OR auto p=make_unique<MyClass>(); - Constructor arguments

}
```

* No leaks guarant&gt;eed - Constructor arguments

**Difficulty**: The following cannot happen because unique pointers cannot be copied

```cpp
unique_ptr<c> p {new C {...}};
unique_ptr<c> q = p;
```

What happens when a unique\_ptr is copied?

* don't want to delete the same pointer twice

Instead - copying is disabled for unique\_ptrs. They can only be moved.

**Sample Implementation \(repo\)**:

```cpp
T *q = p.get(); // gives you pointer inside
```

```cpp
template<typename T> class unique_ptr {
  T* ptr;
  public:
    unique_ptr(T *p): ptr {p} {}
    ~unique_ptr() {delete ptr;}
    unique_ptr(const unique_ptr &other)=delete;
    unique_ptr &operator=(const unique_ptr &other)=delete;
    unique_ptr(unique_ptr &&other): ptr{other.ptr} {
      other.ptr = nullptr;
    }
    unique_ptr &operator=(unique_ptr &&other) {
      std::swap(ptr, other.ptr);
      return *this;
    }
    T &operator *() {
      return *ptr;
    }
}
```

If you need to be able to copy pointers:

* first, answer the question of **ownership**
* Who will own the resource? Who will have responsibility for freeing it?
* That pointer should be a unique\_ptr - all other pointers can be raw pointers \(can fetch the underlying raw pointer with p.get\(\)\)

If there is true shared ownership, i.e. any of several pointers might need to free the resource - use std::shared\_ptr

