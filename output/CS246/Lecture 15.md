# Lecture 15
**Consider the following:**
When is a book heavy?
- ordinary books: >200 pages
- textbooks: >500 pages
- comicbooks: >30 pages

```C++
class Book {
  ...
  protected:
    int length;
  public:
    bool isHeavy() const {
      return length > 200;
    }
};

class Text: public Book {
  ...
  public:
    bool isHeavy() const {
      return length > 500;
    }
};

class Comic: public Book {
  ...
  public:
    bool isHeavy() const {
      return length > 30;
    }
};

// client:
Book b {"small", 50};
Comic c {"Big", 80, "Lushman"};
Book b = Comic{"Big", 80, "Lushman"};
b.isHeavy(); // **What does this return?
```
**It returns false since Book::isHeavy() runs

**Why does ```Book::isHeavy()``` run?**
```C++
Book b = Comic {...};
```
- Tries to fit a comic object in b while there's only space for a Book object
- Comic is **sliced** (i.e. the hero field is chopped off)
- The Comic is a Book now!

```C++
Comic {__, 40, __};
Book *pb = &c;
Book *pc = &c;
```
- When accessing objects through pointers, slicing is unnecessary (so it won't happen)

```C++
pc->isHeavy(); // runs Comic::isHeavy()
pb->isHeavy(); // runs Book::isHeavy()
```
**How does compiler decide which method to run?**
- Uses the **type of the pointer or reference** to decide which isHeavy to run. **(it does not consider the type of the actual object)**
- So a comic is only a comic if you point to it by a comic pointer or reference

**How can we make Comic act like a comic even when pointed to by a Book pointer?**

**Solution**: Declare the method virtual!

## Virtual Methods/Dynamic Dispatch
#### Dynamic Dispatch:
- Type of the object is considered at runtime, rather than from the type of the variable
i.e. Choose which class method to run based on the actual type of the object at run time
- To get dynamic dispatch, you need **virtual methods**
```C++
virtual bool Book::isHeavy() const;
Bool Comic::isHeavy() const override;

// Now:
Comic {__, 40, __};
Comic *pc = &c;
Book *pb = &c;
Book &rb = c;

pc->isHeavy(); // runs Comic::isHeavy()
pb->isHeavy(); // runs Comic::isHeavy()
rb.isHeavy(); // runs Comic::isHeavy()
Book b = c; // runs Book::isHeavy(), you can't stop slicing even if it's virtual!
```
## Polymorphism
- Accomodating multiple types under one abstraction
- Dynamic dispatch allows us to do this

**Example of polymorphic code:**
```C++
Book *myBooks[20];
...
for (int i=0; i < 20; ++i) {
  cout << myBooks[i]->isHeavy();
}
```

**Remark**: This is why we can pass an ifstream to a function
```C++
void f(istream &in);
```
- ifstream is a subclass of istream

***DANGER***:
```C++
class One {
  int n, y;
}

class Two: public One {
  int z;
}

void f(one *n) {
  a[0] = {6,7};
  a[1] = {6,9};
}

Two myArray[2] = {{1,2,3},{4,5,6}};
f(myArray);

// myArray: 1 2 3 | 4 5 6
// a[0] = {6,7}: 6 7 3 | 4 5 6
// a[1] = {8, 9}: 6 7 8 | 9 5 6
// wanted: 6 7 3 | 8 9 6
// compilier thinks it has an order of one's not two's!, therefore misaligned
```

**The Point**: Never use an array of objects polymorphically

## Destructors (Polymorphism)
```C++
class X {
  int *x;
  public:
    x(int n): n{new int[n]}} {};
    ~x() {
      delete [] n;
    }
};

class Y: public X {
  int *y;
  public:
    Y(int n, int m): X{n}, y{new int[m]}} {}
    ~Y() {
      delete [] y;
    }
};

// Y's destructor calls X's destructor!
```
**What happens when an object is destroyed?**
1. Destructor body runs
2. Fields are destructed in reverse dealing order
3. Superclass part is destructed (it's destructor called)
4. space is deallocated

Consider:
```C++
X *myX = new Y{10, 20};
delete myX; // **This leaks, but why?
```
** This calls X's destructor only (since the type of the pointer was X*), Fix this by making X's destructor virtual

**The Point**: Always make the destructor virtual in classes that have subclasses, even if the destructor does not do anything!
- Otherwise when we have a polymorphic variable with the type of the base class, it will not call the destructors of the subclasses

## Final
If a class is not meant to have subclasses, declare it ```final```.
```C++
// Now you cannot make subclasses of Y
class Y final: public X {
  ...
}
```






















