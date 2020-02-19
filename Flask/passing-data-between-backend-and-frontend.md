# Passing Data between Backend and Frontend

### HTML input to Python
```python
from flask import request

@app.route("/hello-world", methods="POST")
def hello_world():
  name = request.form["name"]
  return name
```
```html
<form action="{{ url_for('hello_world') }}"  method="POST">
  <input type="text" id="name" name="name">
</form>
```

### Python to HTML 
```python
from flask import render_template

@app.route("/hello-world", methods="POST")
def hello_world():
  name = "Laura"
  list_of_names = ["Laura", "Amy", "Mary"]
  return render_template(
    "index.html",
    first_name=first_name,
    list_of_names=list_of_names
  )
```
```html
<h2>{{ first_name }}</h2>

{% for name in list_of_names %}
  <h2>{{ name }}</h2>
{% endfor %}


```