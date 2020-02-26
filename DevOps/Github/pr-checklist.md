# PR Checklist

### DevOps

- [ ] Ensure that your branch is up to date with its parent branch
- [ ] Check if Docker database connections are proper (if you are within the same docker container, the sql connection should use the port in export and the host specified in `docker-compose.yml`)

### Error Checks

- [ ] Do a **function search** on all methods that were edited in the repository 
  - Check if method is being used in any unexpected files
- [ ] Request **endpoint** multiple times and ensure that the requests are processed in reasonable time
  - Avoid **timeout** errors
- [ ] Check for places where program can cause API to raise error

### Refactoring Code

- [ ] Check for any **repeating** code blocks
  - Refactor into classes or functions
- [ ] Check if statements for **ternary** use
- [ ] Check for loops for **list/dict comprehension**
- [ ] Made appropriate Wiki for all **endpoints**
- [ ] Check for **strings** that can be replaced with class names or variable names
- [ ] Check all `#pylint-disabled` and try to find a way around it
- [ ] Check if all strings are formatted in either ways: `"{}".format(test)` or` f"{test}"` 

### Documentation

- [ ] Made appropriate **README**

- [ ] Ensure Wiki is up to date

- [ ] Check if there are periods at the end of your sentences

- [ ] Check if comments are captalized

- [ ] Check if all variable names are in the lowercase/underscore format

- [ ] Check if all files are in the lowercase/underscore format

- [ ] Check if all class names are camel case

  