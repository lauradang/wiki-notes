# Lecture 6

### Example
```C++
#include <iostream>
#include <ifstream>
using namespace std;

int main() {
  ifstream file {"suite.txt"}; // opens file during initialization
  string s;
  while (file >> s) {
  cout << s << endl;
  }
} // file is closed when ifstream goes out of scope

```

### ```cin -> ifstream``` input file stream
### ```cout -> ofstream``` output file stream
    ofstream file{"name"}
**Note:** Anywhere cin/cout is usable, an ifstream/ofstream is usable.

### String Streams
An interface to interact with a string like it's a stream.
**Library**: ```include <sstream>```
**Example:** Convert int into a string
```C++
#include <sstream>

string intToString(int n) {
  ostringstream oss;
  oss << n; // cout << n;
  return oss.str();
}
```

**Example:** Convert a string into a number
```C++
int n;
while(true) {
  cout << "Enter a number" << endl;
  string s;
  cin >> s; // cin won't fail unless it is EOF
  istringstream iss{s}; // initialization iss w contents of s
  if (iss >> n) break;
  cout << "I said, ";
}
```
**Example:** print ints to cout, ignore non-ints
```C++
int main() {
  string s;
  while (cin >> s) {
    istringstream iss{s};
    int n;
    if (iss >> n) cout << n << endl;
  }
}
```
Why don't we need to clear and ignore iss?
- Each iteration initializes its own istring stream. 

What will the input "h3110" print?
```C++
// Old version:
>> 3
>> 0

// This version:
 cin >> s // reads "h3110"
 >> 
// prints nothing
```
**Declare string and not initializing**
```C++
string s; // s is an empty string, not null
```
### Default function parameters
**Example:**
```C++
void printSuiteFile(string name="suite.txt") {
  ifstream file {name};
  string s;
  while (file >> s) cout << s << endl;
}
// can call function without calling parameter
printSuiteFile(); // name is default parameter -> "suite.txt"

// can also call function with parameter other than default
printSuiteFile("suite2.txt") // Could also be std::string
```

**Example:**
Optional Parameters must be on the right (if it starts on the left, program will not compile)
eg. ```(int x=5,int y) # will not compile```
```C++
// Can do:
void foo (int x, string s, int z)

// Cannot do:
void foo (int x, string s="hello", int z)

// Can do:
void foo (int x=4, string s="hello", int z=5)
```

### Overloading
Giving multiple functions to one function name in C++, but in C, you must only have unique function names
**Example in C:**
```C
int negInt(int n) { 
  return -n;
}

bool negBool(bool b) {
  return !b;
}
```
**Example in C++:**
```C++
int neg(int n) {
  return -n;
}

bool neg(bool b) {
  return !b;
}
```
**What is a valid overload?**
- Compiler looks at the number and types of parameters.
- Based on **params**, decides the function to call (this decision is made at compile time)
- Overloads must differ in **number** or **types** of args.
- C++ does not overload on **return type**. 
    - i.e. if two functions have the same name and params, but different return types
    - This is not valid because C++ only checks params
- Must be no valid way to call function with same params including default params
  - does not compile if you call function without specifying default param, if it is specified, it will compile

### Structures
**Example:**
```C++
struct Node {
  int n;
  Node *next; // in C++, "struct Node*" is not needed, only need Node*"
}; // semicolon needed
```

**This does not work:**
```C++
struct Node {
  int n;
  Node next;
}
```
Why not?
- size of struct must be known when it is defined
- struct is a recursive class, there is no pointer present  -   - when pointer is present, computer knows the size of the pointer, so it adds the size of a pointer and an int to get the size

### Constants
```C++
const int maxGrade = 100; // consts must be initialized
```
Try to declare as many things const as possible

```C++
Node n1 {5, nullptr}; // synxtax for null pointers in C++, don't use null or 0
```

```C++
const Node n2=n1; // immutable copy of n1 (cannot alter n2)
// Even if you alter n1, it will not alter n2 because it's its own copy
```

### Parameter Passing
**Pass-by-value**: A copy of argument is used in the function
```C++
void inc(int n) {
  ++n;
  ...
};

int main() {
  int x=7;
  inc(x);
  cout << x << endl;
  // pass by value not reference
}

// prints 7 when called
>> 7
```

```C++
void inc(int *n) {
  ++ *n;
  ...
}

int main() {
  int n=7;
  inc(&n); // address of n
  cout << n << endl;
};

// prints 8 when called
>> 8
```
**Why does ```cin >> x``` alter x? Why not ```cin >> &x```?**
- C++ has another pointer-like type called **References**

### References
References are like const pointers with automatic dereferencing.

**Example:**
```C++
int y = 10;
int &z = y; // z is "pointing" to y
z = 12; // NOT *z = 12
cout << y << endl; // prints 12
```
In all cases, z behaves exactly like y.
z is an alias to y -> it's another name for y

```C++
void inc(int &n) {
  ++n;
}

int x=3;
inc(x);
cout << x << endl; // prints 4
```

This is an l value reference:
```C++
int &x; 
```
- l value: left value
- must be initialized to something that can be on the left of an assigment


