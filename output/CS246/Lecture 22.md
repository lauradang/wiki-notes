# Lecture 22

## Ownership
- Owning the resource = ```unique_ptr``` **(OWNS-A)**
- Not owning the resource = ```raw ptr``` **(HAS-A)**
- Shared ownership? This is very rare ```shared_ptr```

## Shared_ptr
**Example of shared_ptr**:
```C++
{ 
  auto p1 = std::make_shared<MyClass>();
  if (...) {
    auto p2 = p1;
  } // p2 popped, pointer not deleted
} // p1 popped, pointer deleted
```
- Shared ptrs maintain a **reference const**
#### Reference const
- Count of all shared_ptrs pointing at the same object
- Memory is freed when the # of shared_ptrs pointing to it is about to reach 0
- Shared pointers have their own destructors (don't need to write one) - so you don't need to worry about double freeing in a list when you have shared ownership

#### Downsides of shared_ptrs
**Do not do this:**
```C++
// Two different reference counts for the same object 
// Made two shared_ptrs on 1 obj
C *p = new C;
shared_ptr<C> p1 {p};
shared_ptr<C> p2 {p};

// do not point a shared_ptr to another shared_ptr (you will create a cycle)
```

## Exception Safety Ctd.
3 levels of exception safety for a function f:

#### 1. Basic Guarantee
- if an exception occurs: program will be left in some **valid state**
- no leaks
- no corrupted data structures
- class invariants maintained

#### 2. Strong Guarantee (you want this most often)
- if an exception is raised while executing f: state of program will **be as it was before it was called**

#### 3. No Throw Guarantee
- f will never throw or propogate an exception
- f will always accomplish its task

**Example of Exception Safety**:
```C++
class A {...};
class B {...};
class C {
  A a;
  B b;
  public:
    void f() {
      a.g(); // May throw (strong guarantee)
      b.h(); // May throw (strong guarantee)
    }
};
```
**Question**: Is ```C::f```'s exception safe?
**Answer**: Analyze what each statement throws:
- if a.g() throws:
  - Nothing in the program has happened yet
  - **Conclusion**: This is **OK**
- if b.h() throws:
  - Effects of g must be undone to offer the strong guarantee
    - Very hard or impossible if g has non-local side-effects
  - **Conclusion**: Probably not exception safe

*So what if A::g and B::h **do not** have non-local side-effects?*

**Answer**: We can use ```copy-and-swap``` as such:
```C++
class C{
  ...
  void f() {
  // if any of these lines throw, the original a and b would still be intact
  A atemp = a;
  B btemp = b;
  atemp.g();
  btemp.h();
  a = atemp; // copy assignment throws
  
  // if this line throws, a has changed, so state is no longer intact - this is no longer strong guarantee
  // the copy assignment throws here too (aka the swap part)
  b = btemp;
  }
}
```
**Solution to this problem**: Would be better if the "swap" part was nothrow because copy assignment pointer cannot throw. **Use pImpl Idiom.**

**FINAL SOLUTION**:
```C++
// This results in a STRONG GUARANTEE - what we want!
struct CImply {
  A a;
  B b;
};

class C {
  unique_ptr<CImpl>pImpl;
  ...
  void f() {
    auto temp = make_unique<CImpl> (*pImpl);
    
    // if the following 2 lines throw, original a and b are still intact - Yay!
    temp->a.g();
    temp->b.h();
    std::swap(pImpl, temp); // No throw
  }
}
```

### Exception Safety and the STL: vectors
#### How do vectors deal with exception safety?
- Encapsulate a heap-allocated array
  - Follows RAII
    - When a stack-allocated vector goes out of scope, the internal heap-allocated array is freed

**Example of Exception Safety with Vector that's good**:
```C++
void f() {
  vector<MyClass> v;
  ...
}
```
**What's happening in the code above?**
- v goes out of scope
- Array is freed
- MyClass destructor runs on all objects in the vector
- everything is all good :)

**Example of Exception Safety with Vector of pointers that's not so good**:
```C++
void g() {
  vector <MyClass *> v;
  ...
}
```
**What's happening in the code above?**
- v goes out of scope
- Array is freed
- Pointers don't have destructors though, so any objects pointed at by the pointers **are not deleted** resulting in **MEMORY LEAK**
- v doesn't know whether the pointers in the array **own** the objects they point at

So why can't you fix this problem by writing this?
```C++
for (auto p:v) delete p // this would work, but it's not proper design
```
If you need to do this, that means the pointer **Own** the objects they point at, and if you just use unique_ptrs, then the deleting would happen by itself.

**Example to a vector of pointers that's good**:
```C++
void h() {
  vector <unique_ptr<MyClass>> v;
  ...
}
```
**What's happening in the code above?**
- v goes out scope
- Array is freed
- unique_ptr destructor runs, so the objects **are deleted**
- No need for **any** explicit deallocation

### How does ```vector<T>::emplace_back``` deal with exception safety?

#### Copy Constructor:
- Offers the **strong guarantee**
  - if the array is full (i.e. size == capacity), then:
    1. Allocate new array
    2. **Copy** objects over (copy constructor)
        - if a copy constructor throws:
          - destroy the new array
          - old array still intact
          - **Strong guarantee**
    3. Delete old array (no throw)

However, 
- Copying is expensive and the old data will be thrown away
- Wouldn't moving the obejcts be more efficient? 

#### Move Constructor:
- if the array is full (i.e. size == capacity), then:
    1. Allocate new array
    2. **Move** the objects over (move constructor)
        - if move constructor throws, then old array is no longer intact
        - **Cannot offer strong guarantee anymore**
    4. Delete old array

**What if move constructor offers the nothrow guarantee?**
- Emplace_back will use the move constructor
- Otherwise it will use the copy constructor - this is **slower**

So your move options should offer the nothrow guarantee, and you should indicate that they do!

**Note**: pointer op, pointer assignments, delete will never throw
```C++
class MyClass {
  public:
    ...
    MyClass(MyClass &&other) noexcept {...}
    MyClass &operator=(MyClass &&other) noexcept {...}
};
```
**Note**: If you know a function will never throw or propogate an exception, declare it noexcept, facilitates optimization.
At minimal, moves and swaps should be noexcept





