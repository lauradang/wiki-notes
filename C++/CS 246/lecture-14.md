# Lecture 14
## Aggregation (HAS-A)
- implies a relationship where the child can exist independently of the parent

**Example with two objects A and B**:
If A "has a" B, then typically:
  - B exists apart from its association with A
    - If A is destroyed, B lives on
    - If A is copied, B is not (shallow copy)
      - copies of A share the same B

eg.  Parts in a catalogue, ducks in a pond
- compare car parts in a car ("owns a") vs. car parts in a catalogue The catalogue contains the parts, but the parts have an independent existence. This is a "has a" relationship (aka aggregation)

**Typical Implementation**: pointer fields

### UML
```C++ 
class Pond { 
  Duck *ducks[maxDucks]; 
} 
```
<img src="/Users/lauradang/Desktop/CS246/UMLs/aggregation.jpg"></img>


### Specialization
**Consider the following**:
```C++
// Tracking a collection of books
class Book {
  string title, author;
  int length;
  
  public: 
    Book (...); // constructor
    ...
}

// For textbooks, there is also a topic:
class Text {
  string title, author;
  int length;
  string topic;
  
  public:
    Text(...); // constructor
    ...
}

// For comics, there is also a hero:
class Comic {
  string title, author, hero;
  
  public:
    Comic(...); // constructor
    ...
}
```
- This is okay, but doesn't capture the relationship among Book, Text, Comic
- Also, how do we create an array (or linked list) that contains a mixture of these?

#### 2 Possible, but Bad Ways to show Relationship between Classes:
1. Use a **union**
```C++
union BookTypes {
  Book *b; 
  Text *t; 
  Comic *c;
};

BookTypes myBooks[20];
```
2. Use an array of ```void*``` (this is a pointer to anything)


**Why are these bad solutions?**
- They subvert the type system
- Notice that Texts and Comics are kinds of Books (books with extra features)

**Best Solution**:
To model in C++: **Inheritance**
## Inheritance (IS-A)
- Is-A Relationship 
- Relationship between Text, Comic, and Book is called "is a"
  - A Text **is-a** Book 
  - A Comic **is a** Book

```C++
// Base class (Superclass)
class Book {
  string title, author;
  int length;
  
  public:
    Book (...); // constructor
    ...
};

// Derived classes or subclasses:
class Text: public Book {
  string topic;
  
  public:
    Text (...); // constructor
    ...
};

class Comic: public Book {
  string hero;
  
  public:
    Comic (...); // constructor
    ...
}
```
#### Derived Classes
- inherit fields and methods from base class
  -  eg. Text and Comic get title, author, length
  - Any method that can be called on Book, can be called on Text and Comic

**Question**: Who can see Book's fields?
**Answer**: Private in Book, so outsiders can't see (not even subclasses)

**Question**: How do we initialize Text or Comic then?
**Answer**: We need title, author, length, topic (initialize the Book part first)

### Initialization with Inheritance
#### Wrong Way:
```C++
class Text: public Book {
  string topic;
  public:
    Text (string title, string author, int length, string topic): 
    title{title}, author{author}, length{length}, topic{topic} {}
    ...
};
```
**Wrong for two reasons**:
1. Title, etc. are not accessible in Text
2. **Once again, when an object is created:**
    1. Space is allocated
    2. Superclass part is constructed. 
    3. Fields constructed
    4. Constructor body runs (And 2 will fail, Book has no default constructor)

**Fix:** invoke Book's constructor in Text's MIL:

#### Correct Way to Initialize Objects of Inherited Classes:
```C++
class Text: public Book {
  string topic;
  public:
    Text (string title, string author, int length, string topic):
      Book {title, author, length}, // step 2 (refer to object creation steps)
      topic {topic} // step 3 (refer to object creation steps)
      {} // step 4 (refer to object creation steps)
};
```
**What if the superclass has no default constructor?**
Subclass must invoke a superclass constructor in its MIL

**Why should the superclass fields be inaccessible to subclasses?**
You don't know what subclass might do -> can't guarantee any invariants

### Protected Visibility
- Protected members are accessible to only the **class and subclasses**

**Bad Example of Protected Visibility**:
```C++
class Book {
  protected:
    // these fields are accessible to Book and its subclasses, but to no one else
    string title, author;
    int length;
  public:
    Book (...);
    ...
};

class Text: public Book {
  string topic;
  public:
  ...
  void addAuthor(string newAuthor) {
    author += newAuthor;
  }
};
```
**BETTER**: Keep fields private, but provide protected accessors
```C++
class Book {
  string title, author;
  int length;
  protected:
    // subclasses can call all these fields
    string getTitle() const;
    void setAuthor(string newAuthor);
  public:
    Book (...);
    book isHeavy() const;
};
```








