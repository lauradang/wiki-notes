# Lecture 19

## Factory Method Pattern
- Methods in this pattern create objects for us, without having to specify which exact type of object to create

#### UML
<img src="/Users/lauradang/Desktop/CS246/UMLs/factory_method_internet.png">

**Factory Method Pattern Example**:
- Write a video game with 2 kinds of enemies: turtle and bullets
- System randomly sends turtle and bullets, but bullets more frequent in harder levels

**Example UML**:
<img src="/Users/lauradang/Desktop/CS246/UMLs/factorymethodpatternUML.jpg"></img>

- Never know exactly which enemy comes next, so can't call turtle/bullet constructors directly
- Instead, put a factory method in Level that creates enemies

```C++
class Level {
  public:
    virtual Enemy *createEnemy()=0;
};

class Easy: public Level {
  public:
    Enemy *createEnemy() override {
      // easy levels would have higher probability of creating turtles randomly rather than bullets

    }
};

class Hard: public Level {
  public: 
    Enemy *createEnemy() override {
        // harder level would have a higher probability of producing a bullet than turtles
        // might also check game progress and generate boss at certain point
    }
};

Level *l = new Easy/Hard
Enemy *e = l->createEnemy();
// the factory method calls the level function to give the correct probability of getting a turtle or a bullet
// we did not call the constructor for an enemy, but the factory method calls it for us
// we also did not have to decide whether to create a turtle or a bullet, since `createEnemy` decides for us
}
```

## Template Method Pattern
- design pattern where we override some behaviour from a superclass, but not all of it 
  - superclass is used as a template for subclass
- **Template Method**:
  - method that outlines an algorithm
  - May have steps of the algorithm call virtual methods (often private) which are implemented in subclass
  - Does most of the work, but subclasses responsible for implementing
- Want subclasses to override superclass behaviour, but some aspects must stay the same
- eg. There are red and green turtles

**Example**:
```C++
class Turtle {
  void drawHead() {
    // draw turtle head
  }
  void drawFeet() {
    // draw turtle feet
  }
  // we used pure virtual but could also provide a default implementation
  virtual void drawShell() = 0;
  
  public:
    void draw() {
      drawHead();
      drawShell(); // this is not yet implemented
      drawFeet();
    }
};

class RedTurtle: public Turtle {
  void drawShell() override {
    // actually draw red shell
  }
};

class GreenTurtle: public Turtle {
  // similar to RedTurtle
};
```
- Subclasses can't change the way a turtle is drawn (head, shell, feet), but can change the way the shell is drawn

**Generalization**: the **Non-Virtual Interface (NVI)** idiom

### Non-Virtual Interface (NVI)
#### Public Virtual Method
- A public virtual method is really 2 things:
  1. Interface to the client (public)
      - indicates provided behaviour with pre/post conditions
  2. Interface to subclasses (virtual)
      - a "hook" to insert specialized behaviour

However, these two are conflicting goals.

**NVI says:**
1. All **public methods** should be **non-virtual.**
2. All **virtual methods** should be **private** (or at least protected)
3. (Except the destructor)

**Example**:
```C++
// Two of the bottom classes do the same thing
// Difference: second one is in control of interface

class DigitalMedia {
  virtual void play() = 0;
};

// or

class DigitalMedia {
  public:
    void play() {
      doPlay(); // can add before/after code
    }
    
  private:
    virtual void doPlay() = 0;
}
```
Generalizes TemplateMethod
- puts every virtual method inside a template method

## STL Maps - For creating dictionaries
eg. "arrays" that map strings to ints
```C++
#include <map>
using namespace std;

// Creating map
map <string, int> m;
m["abc"] = 1;
m["def"] = 4;

// This is not an error, check important note
cout << m["ghi"] << m["def"]; 

m.erase("abc");

// this is the number of keys that match a given key; in a map, this can only be 0 or 1
if (m.count("def")) ... // 0 = not found, 1 = found
```
**Important Note**: If you call a key that does not exist, the map will **create a key with initial value of 0 for ints**

### Iterating over a map
- Iterates in sorted key order
  - i.e. does not iterate in order that you added into the map like an array

```C++
// p's type is std::pair <string,int> (<utility>)

for (auto &p:m) {
  cout << p.first << ' ' << p.secnd << endl;
}
```
- notice ```p.first``` and ```p.second``` are **FIELDS**, not METHODS
- pair is a template structure, and the fields are actually PUBLIC
  - Why is this ok?
    - Because pair is not an abstraction and there is no invariance - you WANT to manipulate the keys (the struct only acts like glues, there are no rules)

## Visitor Pattern
- For implementing **double dispatch**

**Double Dispatch:** Dispatching methods based on type of multiple objects, also used for adding extra functionality to class hierarchy without changing any of the classes in the hierarchy

- Virtual methods in Visitor Pattern are chosen based on the actual type (at runtime) of the receiving object
- What if you want to choose based on two objects?
eg. striking enemies with weapon


### UML
<img src="/Users/lauradang/Desktop/CS246/UMLs/visitorpatternUML.jpg"></img>

- Want something like ```virtual void (Enemy, Weapon)::strike();```
If strike is a method of Enemy - choose based on enemy, but on a weapon
If strike is a method of Weapon - choose based on weapon but not on enemy

The trick is to get dispatch on both (double dispatch)
- combines overriding and overloading

```C++
class Enemy {
  public:
    virtual void beStruckBy (Weapon &w) = 0;
};

// Even though the 2 following classes look the same, they are not
// the strike methods are actual different
class Turtle: public Enemy {
  public:
    void beStruckBy (Weapon &w) override {
      // *this has type Turtle&, so here, it is calling strike overload that takes Turtle
      w.strike(*this);
    }
};

class Bullet: public Enemy {
  public:
    void beStruckBy (Weapon &w) override {
      // *this has type Bullet&, so here it is calling strike overload that takes Bullet
      w.strike(*this);
    }
};

class Weapon {
  // these 2 strike methods are overloads
  virtual void strike (Turtle &t) = 0;
  virtual void strike (Bullet &b) = 0;
};

class Stick: public Weapon {
  public:
    void strike (Turtle &t) override {
      // strike turtle with stick
    }
    void strike (Bullet &b) override {
      // strike bullet with stick
    }
};

Enemy *e = new Bullet;
Weapon *w = new Stick;
e->beStruckBy(w); // What happens**?
```
**```Bullet::beStruckBy``` runs (virtual method)
- calls ```Weapon::strike```, *this is a bullet
  - Bullet version of strike is chosen at compile-time
  - virtual method strike on Weapon resolves to ```Stick::strike(Bullet &b)```















