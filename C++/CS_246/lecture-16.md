# Lecture 16
## Pure Virtual Method
- One where the virtual method of the base class is not implemented (only declared)
- Perhaps because the class is so abstract that it is only meant to be subclassed, never itself instantiated
  - i.e. purpose is to organize subclasses, not create objects
- Cannot declare a variable of this type or call its constructor.
```C++
class Student {
  ...
  public:
    // Method has no (*) impli
    // Called a pure virtual method
    virtual int fees() const = 0;
};

Student s; // would not work (cannot make student objects anymore)
```
### Virtual Method UML Notation:
**UML**: Virtual and pure virtual methods -> indicated by italics
**Abstract classes:** class name in italics
**Protected:** #
**Static:** Underline

## Inheritance and Copy/Move
```C++
class Book {
  public:
  // Defines copy/move ctor
};

class Text: public Book {
    string topic;
    public:
    // Does not define copy/move operations
  };

Text t {"Algorithms", "LLRS", 500, "CS"};
Text t2=t; // No copy ctor in Text. What happens?
```
**What happens?**
- Calls Book's copy constructor
- and then goes field-by-field (i.e. default behaviour for the 'Text' part)
- Same thing happens for other operations

##### To write your own operations for subclasses:
```C++
Text::Text (const Text &other):
  Book {other}, topic {other.topic} {}
  
Text &Text::operator=(const Text &other) {
  Book::operator=(other);
  topic = other.topic;
  return *this;
}

// This will compile but it is wrong (look at note)
Text::Text(Text &&other):
  Book {other}, topic {other.topic} {}

// Look at this one instead
Text::Text(Text &&other): // **
  Book {std::move(other)}, topic {std::move(other.topic)} {} 

Text &Text::operator=(Text &&other) {
  Book::operator=(std::move(other));
  topic = std::move(other.topic);
  return *this;
}
```
****Note:**
- other (so is other.topic) may be pointing at an rvalue, but it is a lvalue so long as the function is not returned yet - Thus, this is actually a **COPY CONSTRUCTOR not MOVE CONSTRUCTOR**
- **std::move(x)** forces an lvalue x to be treated as an rvalue so that the "move" versions of the operations run

**Operations given above are equivalent to the built-in** - specialize as needed

Now consider:
```C++
Text t1{...}, t2{...};
Book *pb1 = &t1, *pb2 = &t2;
```
##### What if we do *pb1 = *pb2?
**Partial assignment** occurs: Copies only the book part
How can we fix this? Try making ```operator=``` virtual

```C++ 
class Book {
  ...
  public:
    virtual Book &operator=(const Book &other) {...}
};

class Text: public Book {
  ...
  public:
    virtual Text &operator=(const Book &other) override {...}
};
```
**Note:** For virtual methods, different return types from the parent class virtual methods are OK, but param types must be the same, or it's not an override (and won't compile); violates "is-a" (inheritance means is-a)

Now, assignment of a Book object to a Text object would be allowed
```C++
Text t{...};
Book b{...};
t=b; // uses a Book to assign a Text, this is bad (but it compiles)

Comic c{...};
t=c; // really bad (mixed assignment)
```
If ```operator=``` is non-virtual - partial assignment through class pointers occurs, which is BAD
If virtual - there is mixed assignment which is BAD

**Recommendation**: All superclasses should be abstract

## Abstract Classes
- Any class with a pure virtual method
  - Since abstract class needs at least one pure method, if you don't have one, use the destructor
  - Virtual destructor MUST be IMPLEMENTED
- subclasses of abstract classes are also abstract unless they implement all pure method

**Concrete**: Class that is not abstract
**Example of Concrete Class**:
```C++
class Regular: public Student { // refer to Student class above
  public: 
    int fees() const override {
      return 700*numCourses
    }
}
```

**Example of Abstract Class:**
- Rewrite Book hierarchy as Abstract:

#### UML:
<img src="/Users/lauradang/Desktop/CS246/UMLs/abstractbook.jpg"></img>

#### Code:
```C++
class AbstractBook {
  string title, author;
  int length;
  protected:
    // prevents assignment through base class pointers from compiling, but implementation still available
    AbstractBook &operator=(const AbstractBook &other); 
  public:
    ...
   // Need at least 1 pure virtual method, so use destructors
    virtual ~AbstractBook() = 0;
};

class NormalBook: public AbstractBook {
    public:
      ...
      NormalBook &operator=(const BormalBook &other) {
        AbstractBook::operator=(other);
        return *this;
      }
      ~NormalBook() {}  // other classes similar
  }
```
**Note:** Virtual destructor MUST be implemented here as said before, even though it is pure virtual 
```C++
AbstractBook::~AbstractBook() {}
```






