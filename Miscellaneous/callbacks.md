# Callbacks

Use callbacks to enforce the order of operations that we want.

```python
users = ["Sam", "Alice", "Bob"]

def addUser(username):
    users.push(username)

def getUsers():
    print(users)

addUser("Jake")

# This might run because addUsers() could be faster (in another region)
getUsers()
```

### Fix

We provide a function as an argument to another function.

```python
users = ["Sam", "Alice", "Bob"]

def addUser(username, callback):
    users.push(username)
    callback() # Calling the function in here

def getUsers():
    print(users)

addUser("Jake". getUsers) # Notice we are passing in getUsers, not getUsers() as we do not want the function to run until inside addUser()

# This might run because addUsers() could be faster (in another region)
getUsers()
```