# Lecture 8

## `make`

* builds main
  * what does main depend on?
    * recursively build dependencies - if necessary
    * then build main - if necessary
* How does make decide it is necessary?
  * checks timestamps \(eg. `ls -l`\)
  * if target is older than its dependencies \(based on last modified time\), it is rebuilt
    * eg. `vec.cc` changes 
    * it is newer than `vec.o`
    * rebuild `vec.o` 
      * newer than main \(executable\)
      * rebuild main

        **`make clean`**
* full rebuild

## Generalize with variables

**This file is in repository \(example3 Makefile\):**

```cpp
cxx = g++ // compiler's name
CXXFLAGS = -std=C++14   -Wall // compiler options
OBJECTS = main.o vec.o
EXEC = main

${EXEC}: ${OBJECTS}
  ${CXX} ${CXXFLAGS} ${OBJECTS} -o ${EXEC}
```

* main.o: main.cc vec.h
* vec.o: vec.cc vec.h

### Biggest problem with writing makefiles

* writing dependencies and keeping them up to date
* can ge help from g++: `g++ -MMD -c vec.cc`
  * creates vec.o and vec.d

Vec.d: `vec.o: vec.cc vec.h`

* Now just include this in the Makefile

**To get this file, edit Makefile in repository**

```cpp
cxx = g++ // compiler's name 
CXXFLAGS = -std=C++14 -Wall -MMD -g
OBJECTS = main.o vec.o 
DEPENDS = ${OBJECTS:o=.d}
EXEC = main 
${EXEC}: ${OBJECTS} 
  ${CXX} ${CXXFLAGS} ${OBJECTS} -o ${EXEC}
- include ${DEPENDS}
```

## What if we want a module to provide a global variable?

Wrong way to do it:

```cpp
// File: abc.h
int globalNum; // declaration and definition
```

* Every file that includes abc.h defines a separate globalNum - program will not link

**Solution**: put variable in `.cc` file

```cpp
// File: abc.cc
int globalNum; // definition
```

```cpp
// File: abc.h
extern int globalNum; // declaration, but not a definition
```

**Suppose we write a linear algebra module** - code found in `separate/example3`

* Does not compile because `#include "vec.h"` is included twice in `main.cc`, and struct vec cannot be defined twice
* Need to prevent files from being included more than once

**Solution:** `#include guard`

```cpp
// File: vec.h
#ifndef VEC_H
#define VEC_H
... // file contents
#endif
```

* First time vec.h is included - symbol VEC\_H is not defined, so file is included
* Subsequently, VEC\_H is defined, so contents of vec.h are suppressed
* **Always**
  * put `#include guards` in .h files
* **Never** 
  * put `using namespace std;` in .h files
    * the usage directive will be forced upon any client that includes the file
    * always say `std::cin, std::string, etc.` in headers
  * compile .h files \(these are compiled by being included .cc files\)

## Classes

* Can put functions inside of structs

  eg. 

  \`\`\`C++

  // File: student.h

struct Student { int assns, m+, final; float grade\(\); };

```text
```C++
// File: student.cc

#include "student.h"

// Wrong way:
float grade(); // Compiler thinks you are writing a whole new function called grade(), not one connected to struct Student

// Correct way:
float Student::grade() {
  return assns*0.4 + mt*0.2 + final*0.4;
}
```

**Class**: structure type that can have functions **Object**: an instance of a class **Member function/Method**: function inside class \(eg. grade\(\) in Student\) **Scope resolution operator**: `::` eg. C::f means f is in the context of the class \(or namespace\) C. **:: like .**, where LHS is a class \(or namespace\), not an object

```cpp
// client:

// Student is the class
// s{60,70,80} is the object
Student s{60,70,80},
cout << s.grade() << endl
```

**What do assns, mt, final mean inside of `Student::grade`?**

* Key are the fields of the current object - the object upon which grade was called

```cpp
Student billy {...}
billy.grade(); // method call
```

**Difference between method and function**

* Methods take a hidden extra parameter: `this`
  * a pointer to the object on which the method was called

    ```cpp
    billy.grade(); // this == &billy
    ```
* Can write:

  ```cpp
  struct Student {
  ...
  float grade() { // method bodies can be written inside the class, lectures will do it for brevity, you should put them in .cc files
  return this->assns*0.4 + this->mt*0.2 + this->final*0.4
  }
  };
  ```

## Initializing Objects

```c
Student billy {60,70,80} // intializing struct in C, OK, but limited
```

**Better way**:

* write a method that initializes: **Constructor**

  \`\`\`C++

  struct Student {

  int assns, mt, final;

  float grade\(\);

  Student \(int assns, int mt, int final\(\);\)

  };

Student::Student \(int assns, int mt, int final\) { this-&gt;assns=assns; this-&gt;mt=mt; this-&gt;final=final; }

Student billy {60,70,80}; //better way done!

\`\`\`

