# Lecture 18

### Design Patterns Continued
**Guiding Principle**: Program to the interface, not the implementation
  - Abstract base classes define the interface
    - they work with base class pointers and call their methods
  - Concrete subclasses can be swapped in and out
    - Abstraction over a variety of behaviours
    
**The point:** Even if you don't have an abstract base class, you should probably make one anyway

###  Iterator Pattern
```C++
class List {
  ...
  public:
    class Iterator: public AbstractIterator {
      ...
    };
};

class AbstractIterator {
  public:
    virtual int &operator*()=0;
    virtual AbstractIterator &operator++=0;
    virtual bool operator!=(AbstractIterator &other)=0;
    virtual ~AbstractIterator() {};
};

class Set {
  ...
  public:
    class Iterator: public AbstractIterator {
      ...
    }; 
};

// Then you can write code that operators over iterators.

// works over Lists and Sets
void for_each(Abstract Iterator &start, AbstractIterator &finish, int(*f)(int)) {
  while (start != finish) {
    f(*start);
    ++start;
  }
}
```

## Observer Pattern
- Aka Publish/subscribe model
- Publisher/Subject generates data
- Observers/Subscribers receive data and react to it
  - i.e. Observers/Subscribers automatically updates when subject's data changes
  
**General Example:**
- **publisher** = spreadsheet cells
- **observers** = graphs (when spreadsheet cells change, graph reacts)

**Note**: Can be many different kinds of observer objects - subject should not need to know all the details

#### UML
<img src="/Users/lauradang/Desktop/CS246/UMLs/observerpatternuml.jpg"></img>

**UML Note**: Subject class is code common to all subjects, Observer class is interface common to all observers


### Observer Pattern's Sequence of Method calls
1. .```Subject```'s state is updated
2. .```Subject::notifyObservers()``` - calls each observer's ```notify()```
3. Each observer calls ```ConcreteSubject::getState()``` to query the state and reacts accordingly

**Observer Pattern Example**:
- **Subject** - publishes winners
- **Observers** = individual bettors (they'll declare victory when their horse wins)

```C++
// Subject Class
class Subject {
  vector<Observer*> observers;
  
  public:
    void attach(Observer *ob) {
      observers.emplace_back(ob);
    }
    
    void detach(Observer *ab); // remove from observers (must loop through)
    
    void notifyObservers() {
      for (auto &ob:observers) {
        ob->notify();
      }
    }
    
    virtual ~Subject();    
};

Subject::~Subject() {}

// Observer class
class Observer {
  public:
    virtual void notify() = 0;
    virtual ~Observer() {}
};

// ConcreteSubject class
class HorseRace: public Subject {
  ifstream in; // source of data
  string lastWinner;
  
  public:
    HorseRace(string source): in{source} {}
    
    bool runRace() {
      return in >> lastWinner;
    }
    
    string getState() {
      return lastWinner;
    }
};

// ConcreteObserver class
class Bettor: public Observer {
  HorseRace *subject;
  string name, myHorse;
  
  public:
    Bettor(Horse Race *subject, string name, string myHorse) {
      subject->attach(this);
    }
    
    ~Bettor() {
      subject->detach(this);
    }
    
    void notify() {
      string winner = subject->getState();
      if (winner == myHorse) {
        cout << "win!" << endl;
      } else {
        cout << "Lose :(" << endl;
      }
    }
}

int main() {
  HorseRace hr;
  Bettor Larry {&hr, "Larry", "OliviaTheFuckFace"};
  while (hr.runRace()) {
    hr.notifyObservers();
  }
}
```

## Decorator Pattern
- Used to enhance an object during runtime
  - i.e. Add functionality/features when program is running
  
**Example**: Windowing system 
- start with basic window
- add scrollbar
- add menu

#### UML
<img src="/Users/lauradang/Desktop/CS246/UMLs/decoratorpatternUML.jpg"></img>

**```Component```** **defines** the interface - i.e. operations your objects will provide
**```ConcreteComponent```** **implements** the interface.
**```Decorators```** - all inherit from ```Decorator```, which inherits from ```Component```

Therefore, every decorator **IS-A** ```Component``` and **HAS-A** component.

**Window example explained**:
- WindowWithScrollBar is a kind of window and has a pointer to the underlying plain window
- WindowWithScrollBar and menu IS a window and HAS a pointer to a WindowWithScrollBar, which has a pointer to a window
- pointer always points to a less deccorated version of itself

All inherit from WindowInterface, so Window methods can be used polymorphically on all of them.

**Decorator Pattern Example with Code**: Pizza
```C++
// Basic pizza is crust and sauce

// Component Class (Abstract)
class Pizza {
  public:
    virtual float price() const=0;
    virtual string desc() const=0;
    virtual ~Pizza() {}
};

// Decorator Class (Abstract)
class Decorator: public Pizza {
  protected:
    Pizza *component;
  public:
    Decorator (Pizza *p): component{p} {}
    virtual ~Decorator() {
      delete component;
    }
}

// ConcreteDecorator Class
class CrustAndSauce: public Pizza {
  public:
    float price() const override {
      return 5.99;
    }
    
    string desc() const override {
      return "pizza";
    }
};

class StuffedCrust: public Decorator {
  public:
    stuffedCrust (Pizza *p): Decorator {p} {}
    
    float price() const override {
      return component->price() + 2.69;
    }
    
    string desc() const override {
      return component->desc() + "with stuffed crust";
    }
}

// Other classes are similar to StuffedCrust
```
### UML
<img src="/Users/lauradang/Desktop/CS246/UMLs/decoratorpizzaUML.jpg"></img>