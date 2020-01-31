# Assignment 3

## Question 1

* Write a C++ class \(as a srtuct\)

**What is a rational \#?**

* n/d
  * n = integer
  * d = non-0 int
* when d=1, n/d is an integer, so INTEGER COUNTS
* Negative rational \#s:
  * neg num
  * pos denom
* `rational.h`
  * has all methods and func to implement
  * implement in rational.cc

**Functions to implement**

1. Constructor: `Rational(int num=0, int den =1);`
2. Overload +,-,\*,/ to operate on 2 rational numbers
3. Negate rational num
4. +=,-= operator
5. simplify\(\)
6. getNumerator\(\)
7. getDenominator\(\)
8. overloaded input operator:
   * reading rational \#s: int-value-for-numerator/int-value-for-denominator
   * arbitrary amounts of whitespace permitted before or in between terms
9. overloaded output operator
10. numerator/denominator \(no whitespace\)
    * rational nums that have denominator 1 printed as 17

## Question 2

* Write a `Polynomial` class
* using `Rational` class from Q1
* create
* print
* subtract
* add
* multiply
* divide
* move\_assign
* move\_copy

### Test cases:

* test for white spaces \(space and tab\)
* divide bigger poly and smaller
* divide for exact polys \(0 remainder\)
* divide with remainder
* different degrees to multiply \(multiply with ones that are missing things in between\)

## Question 3

* main.cc
  * target: source
    * target depends on source \(both files\)
  * touch file
    * int ticker is updated \(successful or not\)
    * file has been updated
    * if file DNE, ignored
  * make file
    * file should be rebuilt
    * if file DNE, ignored

When is target rebuilt?

* when any target it depends on is newer than target itself
* last modified time should be set to current modified time
* every target starts w 0

### Errors:

* updating target directly \(that's an error\)
* exceeding 10 file dependency
  * stdout:Max dependencies exceeded, don't end program
  * giving file same dependency counts as 1 dependency
    * giving file same dependency is just ignored \(this only applies directly, if indirect, it's a different story\)
* exceeding 20 targets
  * stdout:Max targets exceeded \(don't end program\)
    * eg. a:b, a:c creates 3 targets \(a,b,c\)

### Test cases:

* touch file DNE
* make file DNE

## Question 4

