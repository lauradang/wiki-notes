# Lecture 5

### Function from last lecture

```cpp
# include <iostream>
using namespace std; 

int main() { 
  int x,y; cin >> x >> y; // read two integers from cin, skipping whitespace 
  cout << x+y << endl; // reads whitespace delimited input 
}
```

* Input fed into this function might not be an int
  * could be a number that doesn't fit in an int

### Failure to Read Int

* 0 is stored into int
* cin is set to know we failed to read from it
* If read fails, `cin.fail()` will be true
* If `EOF`, then `cin.eof()`, and `cin.fail()` are both true
* If `cin` takes something that is bigger than an int, long, etc. It will fail, otherwise, will do implicit conversion

### Example 1:

**Read all ints from cin, and echo them one per line to stdout. Stop if EOF or a non-int is entered.**

```cpp
# include <iostream>
using namespace std; 

int main(){
  int i;
  while (true) {
    cin >> i;
    if (cin.fail()) break;
    cout << i << endl;
  }
}
```

#### There is an implicit conversion from cin to bool:

```cpp
// if cin hasn't failed or reached EOF then it is true
if (cin) { 
  ...
}
```

### `>>`

* C's right bit shift operator

  ```cpp
  // shifts a's bits to the right by b bits
  a >> b
  ```

* The operator `>>` with `cin` as the first operand, C++ will call the "get from" version of operator `>>`.

  ```cpp
  cin >> x >> y >> x; // cascading
  // runs cin >> x first, then cin >> y, then cin >> z
  // always returns cin
  // if one cin step fails, it will return cin with cin.fail() set to true (does not read anymore, just quits)
  ```

### Rewrite Example 1:

```cpp
# include <iostream>
using namespace std; 

int main() {
  int i;
// attempts to read i and returns cin which is implicitly converted to a bool
// if read succeeds, while loop runs
  while (cin >> i) { 
    cout << i << endl;
  }
}
```

### Example:

**Read ints from input until we reach EOF. Ignore any non-integers.**

```cpp
# include <iostream>
using namespace std; 

int main() {
  int i;
  while (true) {
    if (!(cin >> i)) {
      cout << i << endl;
      if (cin.eof()) break;
      else {
        cin.clear(); // clears cin's fail bit
        cin.ignore(); // removes the char from stream
      }
    } 
  }

  int j;
  cin.clear();
  cin >> j;
  cout << "This is the last int: " << j << endl;
}

// run file in terminal
$ g++ -std=c++14 readInts5.cc -o readInts
$ ./readInts
```

### Example

**Print hexadecimal representation of 95.**

```cpp
cout << hex << 95 << endl;
std::hex // an IO manipulator
// All subsequent ints printed in hexadecimal
cout << dec;
cout << bin; // binary, stored in <iomanip>
```

## Strings

In C: an array of chars `char* or char[]`

* Terminated with '\0'
* Explicit memory management
* bad if null terminator was forgotten

In C++: `#include <string> type std::string`

* manage their own memory 
* string takes care of termination 
  * easier to manipulate

### Initialization

```cpp
string s = "hello";
```

* "hello" is still a string literal 
  * still a C-style string
* s is initialized from the literal string and maintains its characters

### String Operations

```cpp
s1 == s2;
s1 != s2;
s1 <= s2; // lexicographical
s1.length(); // length in constant time
s[0]; // fetch chars
s3 = s1 + s2; // concatenation
s3 += s4; // short form concatenation
s.substr(n,m) // n = first char to grab, m = # of char to grab, returns C++ style string
```

### Example

```cpp
int main() {
  string s;
  // Reads string -> whitespace delimited (skips leading whitespaces)
  // Stop reading at next whitespace char
  cin >> s; 
  cout << s << endl;
}
```

#### Reading with whitespace: `getline(cin, s)`

* Reads entire line until a newline character
* Other delimiters possible

### File Access

```cpp
# include <iostream>
# include <fstream> // file streams
using namespace std;

int main() {
  ifstream file { "name.txt" };
  // Declaring and initializing on ifstream. Opens file
  int x;
  file >> x; // file instead of cin (works the same way)
}
```

