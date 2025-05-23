# Lecture 23

## Casting
- Allows us to bypass the type system - a manual override for type checking
- Often a source of error

**Casting Example in C**: 
```C 
struct Node n; int \*ip = (int\*) &n; 
// cast - forces C to treat a Node* as an int*. 
```
- C-style casts should be avoided in C++. If you must cast, use C++ cast.

**Four kinds of casting in C++ (raw pointers):**
1. static_cast
2. reinterpret_cast
3. const_cast
4. dynamic_cast


**Four kinds of casting in C++ (smart pointers):**
1. static_pointer_cast
2. reinterpret_pointer_cast
3. const_pointer_cast
4. dynamic_pointer_cast

#### ```static_cast```
- Converts one type to another
- relatively safe 
  - compiler gives error if  cast doesn't make sense, though it won't catch everything
- If a casted value isn't actually of the desired type, the behaviour is undefined.
- "sensible casts"

**Example 1**:
```C++
// Converting double to int
double d;
void f(int x);
void f(double x);
f(static_cast<int>(d)); // calls code on line 2
```
**Example 2**:
```C++
// Converting superclass pointer to subclass pointer
Book *b = new Text{...};
Text *t = static_cast<Text*>(b); // t->getTopic() is OK

// You are taking responsibility that b actually points at Text 
```

#### ```reinterpret_cast```
- Converts one type to another without checking if it is reasonable
- Unsafe, implementation-specific, "weird" casts (kind of opposite of ```static_cast```)
- compiler dependent way of casting
- Similar to ```static_cast``` but doesn't check if cast makes sense

**Example**:
```C++
Student s;
Turtle *t = reinterpret_cast<Turtle*>(&s);
```

#### ```const_cast```
- For converting between const and non-const
- the only C++ cast that can "cast away const"
- Can create cascading errors in your program (if you fix cast one const, then the next part of program may have type errors with const)

**Example**:
```C++
// Something you can't do:
void g(int *p);
void f(const int *p) {
  ...
  g(p); // you cannot do this, p is a const int, not an int
  ...
}

// Something you can do:
// So this is why you use const_cast:
void g(int *p);
void f(const int *p) {
  ...
  g(const_cast<int*>(p)); 
  ...
}
```
#### ```dynamic_cast```
- Safely converts one type to another
- Can use dynamic casting to make decisions based on an object's **run-time type information (RTTI)**
- Only works on classes with at least 1 virtual method
- Works with references

**Example**:
```C++
// Is it safe to convert a Book* to a Text*? - depends on what pointer is pointing at
Book *pb;
static_cast<Text*>(pb)->getTopic(); // is this safe?

// Better to do a tentative cast (try it and see if it works)
Book *pb = ______;
Text *pt = dynamic_cast<Text*>(pb);
```
- If the cast works (```*pb``` really is a ```Text``` or a subclass of ```Text```), ```pt``` points at the objects.
- If the cast fails, ```pt``` will be nullptr
```C++
if (pt) {
  cout << pt->getTopic();
} else {
  cout << "Not a Text";
}
```

#### ```dynamic_cast``` with References
- Can be used to solve the polymorphic assignment problem

**Example with References**:
```C++
Text t{...};
Book &b = t;
Text &t2 = dynamic_cast<Text&>(b);
```
- If b "points to" a ```Text```, t2 is a reference to the same ```Text```
- If not...? (No such thing as a null reference)
  - So an **exception** is raised - ```bad_cast```

**How can referencing be used to solve the polymorphic assignment problem?**
```C++
Text &Text::operator=(const Book &other) { // virtual
  // if other is not a Text, line 3 will throw, and the following code will not execute
  const Text &textOther = dynamic_cast<const Text&>(other);
  if (this == &textOther) {
    return *this;
  }
  Book::operator=(other);
  topic = textOther.topic;
  return *this;
}
```

#### ```dynamic_pointer_cast```
- cast shared_ptrs to shared_ptr

**Bad Design Example**:
- Code like this is tightly coupled to the ```Book``` hierarchy
- May indicate bad design
```C++ 
void whatIsIt(shared_ptrb) { 
  if (dynamic_pointer_cast(b)) { 
    cout << "Comic"; 
  } else if (dynamic_pointer_cast<Text>(b)) {
    cout << "Text";
  } else {
    cout << "Normal book";
  }
```
**Solution**: 
1. Use virtual methods
2. Write a Visitor (if possible)

#### More Notes on Casting
- Why can't we just use ```dynamic_cast``` for everything if it's safest?
  - it requires more processing power

## How Virtual Methods Work
```C++
class Vec {
  int x,y;
  public:
    void f() {...}
};

class Vec2 {
  int x,y;
  public:
    virtual void f() {...}
};

// What's the difference between these 2 classes? Do they look the same in memory?
Vec v{1,2}; 
Vec w{1,2};

cout << sizeof(v) << ' ' << sizeof(w) << endl; // outputs 8 16
```
**Why is w double the size of v?**
- v:
  - 8 is space for 2 ints
  - 0 space for ```f()``` 
- w:
  - has a vptr (explained in following notes)

**Note**: Compiler turns methods into ordinary functions and stores them separately from objects

**Recall**: 
```C++
Book *pb = new {...} // replace ... with Book, Text, or Comic
auto pb = make_unique<...>() // replace ... with Book, Text, or Comic
pb->isHeavy();
```
- If ```isHeavy()``` is virtual, the choice of which version to run is based on the type of the actual object - which the compiler can't known in advance
- Therefore, ```isHeavy()``` must be chosen at runtime. How is this done?

#### Compiler choosing which method is correct at runtime
- For each class with virtual methods, the compiler creates a table of function pointers (the vtable)
```C++
class C {
  int x, y;
  virtual void f();
  virtual void g();
  void h();
  virtual ~C();
};
```
C objects have an extra pointer (the vptr) that points to C's vtable.

















