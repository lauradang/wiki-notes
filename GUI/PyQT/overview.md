# Overview

## In all applications:

- All PyQT applications have **1** instance of `QApplication`.

  ```python
  from PyQt5.QtWidgets import QApplication
  app = QApplication([]) # [] are the command line arguments
  ```

- Hand control to Qt and actually run the app after it has been created until the user closes the application

```python
app.exec_()
```

## Layout/Widgets

- Need a window to place widgets like buttons

```python
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout
app = QApplication([])

window = QWidget() # Acts as a container (no fancy behaviour)
layout = QVBoxLayout()
layout.addWidget(QPushButton("Button"))
window.setLayout(layout)
window.show()

app.exec_()
```

## Style

- Examples: *Fusion, Windows, Macintosh, WindowsVista* (dependent on platform)
- [Dark Fusion](https://gist.github.com/mstuttgart/37c0e6d8f67a0611674e08294f3daef7)

```python
from PyQt5.QtWidgets import *
app = QApplication([])

# Colour
app.setStyle('Fusion') # Setting style
palette = QPalette() # Initializing palette for colours
palette.setColor(QPalette.ButtonText, Qt.red) # Adding colour to style
app.setPalette(palette)

# StyleSheet
app.setStyleSheet("QPushButton { margin: 10ex; }") # Add style sheet to button 

button = QPushButton('Hello World')
button.show()
app.exec_()
```

## Signals/Slots

- Reaction to events (like when user clicks a button)

```python
from PyQt5.QtWidgets import *
app = QApplication([])
button = QPushButton('Click')

def on_button_clicked():
    alert = QMessageBox()
    alert.setText('You clicked the button!')
    alert.exec_()
    
# button.clicked is a signal, .connect is a slot (function that's called after signal)
button.clicked.connect(on_button_clicked) 

button.show()
app.exec_()
```

## Compiling App

- How do you give this app to others (without the source code)?
  - Create binary exectuable

```bash
$ pip install fbs
$ fbs startproject
$ fbs freeze
```

**Note**: Only for people with the same OS as you.

