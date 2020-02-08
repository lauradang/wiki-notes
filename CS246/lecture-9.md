# Lecture 9
### Class
- Big innovation in OOP
- Can put functions inside a struct


**Example:** 
```C++
// file: student.h

#ifndef STUDENT_H
#define STUDENT_H

struct student {
  int assns, mt, final;
  float grade(); // forward declaration
};

// file: student.cc

#include "student.h"
float Student::grade() { // veru similar to std::
return this->assns*0.5+this->mt*0.2+this->final*0.4;
}

Student billy {70, 50, 75};
Student billy = {70, 50, 75};
billy.grade();
```
**Class**: A struct that contains functions
- every C++ struct can contain functions
- An instance/value of a class is called an object 
  - I.e. Billy is an object


**Member**: Function within a class
- eg. grade(); //invalid
- Must use object to call a method
- methods are called on objects
- Within method call, method has access fields of the object


**Methods**
- have hidden parameter
  - "this"
  - "this" points to object used to call method
eg.
```
this == &billy => (*this == billy)
this->assns == (*this).assns
```

**Style Initialization**:
```
student billy {70,50,75};
```
- requires "parameters" to be compile time constant
- C++ allows special methods called **constructors** to construct objects

**Example:**
```C++
// file: student.h

struct Student {
  int assns, my, final;
  ...
  Student(int assns, int mt, int final); // constructor - same name as class
};

// file: student.cc

Student::student(int assns, int mt, int final);
this->assns=assns;
this->mt=mt;
this->final=final;
```

**Compare**:
```C++

// Initializing using constructor
// constructor has 3 ints in parameters, so this works
Student billy {70,50,75}; // goes to c-style intialization if no constructor


// Initializing without constructor
// if constructor does not take any arguments, then you would do this
Student billy = {70,70,75};

// Putting "billy" on the heap, not the stack

Student *pbilly = new Student {70, 50, 75};
delete pbilly;
```

**Advantages of Constructors**:
- args do not need to be constants
- method overloading (different parameters)
- ctor body can execute any code
  - ex. sanity checks
- default args

**Example:**
```C++
// file: student.h

struct Student {
  Student(int assns=0, int mt=0, int final=0); // default value in header file only
}

// file: student.cc
Student::Student(int assns, int mt, int final) {
this->assns = assns < 0? 0:assns;
this->mt = mt < 0? 0:mt;
this->final = final < 0? 0:final;
}

Student s2 {80, 60}; // final=0
Student s3 {75}; // mt=final=0
Student s4 {}; // mt=final=assns=0
Student s4;

int main() {
  // requires a 3 parameter constructor
  // (only available when program is running, cannot do c-style intialization => not constants)
  int x,y,z;
  cin >> x >> y >> z;
  Student s {x, y, z};
}
```
### Default Constructor
Every class comes with a default ctor
- ctor with 0 parameters
- calls default ctors on fields that are objects
**Example**
```C++
struct MyStruct {
  int x;  // calls default ctor
  Student y;  // x, p will not be initialized
  Vec *p; // y has been initialized
};
```
- ctor body -> too late to initialize constant
- Hijack step 2 to intialize constants/references
- MIL: Members Initialization List



















