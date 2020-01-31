# Lecture 12

Recall const obj, const methods

```cpp
struct Student {
  int assns, mt, final; 
  float grade() const; //doesn't modify fields, so declare it const
}
```

Now consider: We want to collect usage stats on student objects

```cpp
struct Student {
  ...
  int numMethodCalls = 0;

  float grade() const { 
    ++numMethodCalls;
    return ... ;
  }
}
```

If you remove const from grade\(\), then you cannot call grade on const Students, but mutating numMethodCalls affects only the physical constness of student objects, not logical constness.

We want to be able to update numMethodCalls even if the object is const. **ANSWER:** Declare **field mutable**

```cpp
struct Student {
  ...
  mutable int numMethodCalls = 0;
  float grade const() {
    ++numMethodCalls;
    return ...;
  }
}
```

## Static Fields and Methods

* numMethodCalls tracked number of times method was called on for particular object.

What if we want to track the number of times a method is called over all student objs? Or what if we want to track how many students are created? **ANSWER**: Static members!

