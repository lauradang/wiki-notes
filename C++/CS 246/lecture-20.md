# Lecture 20

Recall turtle and weapon example in last lecture.

## Visitor Pattern Ctd.
- visitor can be used to add functionality to existing classes, without changing or recompiling the classes themselves
eg. Add a visitor to the Book hierarchy

```C++
// Compare this example to the turtle/weapon example
class Book { // Enemy
  public:
    virtual void accept (BookVisitor &v) { // beStruckBy
      v.visit(*this);
    }
};

class Text: public Book {
  public:
    void accept (BookVisitor &v) {
      v.visit(*this);
    }
};

class BookVisitor { // Weapon
  public:
    virtual void visit(Book &b) = 0; // strike
    virtual void visit(Text &t) = 0;
    virtual void visit(Comic &c) = 0;
};
```
**Application**: Track how many of each type of Book I have
- Books: by author
- Texts: by topic
- Comics: by hero

How to collect this information?
- Use a ```map<string, int>```
  - Could write a ```virtual updateMap``` method
- OR write a visitor:

```C++
// look at cs246/1199/lectures/se/visitor example 
struct Catalogue: public BookVisitor {
  map<string, int> theCat;
  void visit(Book &b) override {
    ++theCat[b.getAuthor()];
  }
  void visit(Text &t) override {
    ++theCat[t.getTopic()];
  }
  void visit(Comic &c) override {
    ++theCat[c.getHero()];
  }
};
```
- Won't compile - there is a cycle of includes
- Book and BookVisitor include each other
  - whichever is first won't know about the second

## Compilation Dependencies
- When does a file *need* to ```#include``` another file?

**Consider**: Which of the following classes need to ```#include "a.h"```
```C++
class A {...}; // a.h

// inherits from A (need to know the size of A)
#include "a.h"
class B: public A {...};


// is not a pointer here, you need to know the size of A
// so you have to include a.h here
#include "a.h"
class C: {
  A a;
};

// has a pointer of type A, but pointers always have same size
// so knowing A exists is good enough for class D
// so not including a.h is fine here
class D: {
  A *pa;
};

// function is not implemented yet, only declared, so do not details about A
class E {
  A f(A a);
};

// Need details about A
#include "a.h"
class F{
  A f(A a) {
    a.g()
  }
}
```
**The Point:** If the code doesn't need an ```#include```, don't create a needless compilation dependency by including unnecessarily.

When A changes, only A,B,C,F need recompilation
In the implementations of D,E:
```C++
// d.cc

#include "a.h"
void D::f() {
  pa->something(); // Need knowledge of A
}
```
Do the include in the .cc file instead of the .h file (where possible)

Now consider the XWindow class:
```C++
// this is all private data, but we can look at it
// **Do we know what it all means? Do we care?
class XWindow {
  Display *d;
  Window w;
  int s;
  GC gc;
  unsigned long colours[10];
  public:
    ...
};
```
**What if I need to add or change a private member?
All clients must recompile, would be better to hide these details away.

**Solution**:
## Bridge Pattern
### Pimpl Idiom (Pointer to Implementation)

Create a second class XWindowImpl:

```C++
// XWindow Impl.h:
#include <Xll/Xlib.h>

struct XWindowImpl {
  Display *d;
  Window w;
  int s;
  GC gc;
  unsigned long colours[10];
};

// Window.h
class XWindowImpl;
class XWindow {
  XWindowImpl *pImpl;
  public:
    ... // no change  
};
```
- No need to include Xlib.h
- Forward declare the impl class
- No compilation dependency on XWindowImpl.h
- Clients also don't depend on XImpl.h

```C++
// Window.cc
#include "Window.h"
#include "XWindowImpl.h"

XWindow::XWindow(...);
pImpl {
  new XWindowImpl {...};
}
XWindow::~xWindow() {
  delete pImpl;
}
```
- Other methods 
  - replace fields d, w, s, gc, colours with ```pImpl->d, pImpl->w```, etc.

Changing private fields => only recompile Window.cc and relink

**Generalization**: What if there are several possible window implementations, say XWindow and YWindow
- then make Impl struct a superclass

### UML
- pImpl idiom and hierarchy or implementation is called the Bridge Pattern

<img src=/Users/lauradang/Desktop/CS246/UMLs/bridgepattern.jpg>








































