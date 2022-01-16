# PR Checklist

### DevOps

- [x] Ensure that your branch is up to date with its parent branch
- [x] Check if Docker database connections are proper (if you are within the same docker container, the sql connection should use the port in export and the host specified in `docker-compose.yml`)
- [ ] `pip freeze > requirements.txt` and rebuild your Docker image to make sure everything still works
- [ ] Check if all the files that you renamed have been renamed in Git

### Error Checks

- [x] Do a **function search** on all methods that were edited in the repository 
  - Check if method is being used in any unexpected files
- [x] Request **endpoint** multiple times and ensure that the requests are processed in reasonable time
  - Avoid **timeout** errors
- [x] Check for places where program can cause API to raise error

### Refactoring Code

- [x] Check for any **repeating** code blocks
  - Refactor into classes or functions
- [x] Check if statements for **ternary** use
- [x] Check for loops for **list/dict comprehension**
- [x] Check for **strings** that can be replaced with class names or variable names
- [x] Check all `#pylint-disabled` and try to find a way around it
- [x] Check if all strings are formatted in either ways: `"{}".format(test)` or` f"{test}"` 

### Documentation

- [x] Made appropriate **README**
- [x] Ensure Wiki is up to date
- [x] Check if all functions and classes have docstrings
- [x] Check if all parameters (class - fields, functions - methods) have docstrings 
- [x] Check if there are periods at the end of your sentences
- [x] Check if comments are captalized
- [x] Check if all variable names are in the lowercase/underscore format
- [x] Check if all files are in the lowercase/underscore format
- [x] Check if all class names are camel case
- [x] Make sure it says "Parameters", not "Args"
- [x] Check if all parameters are specified in "Parameters"

### Style

- [x] Delete unnecessary newlines and trailing spaces
- [x] Ensure there is a new line at the end of each file
- [x] Ensure there are two new lines separating `if name == main` and the rest of the program