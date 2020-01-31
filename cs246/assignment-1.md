# Assignment 1

## Q1i

### Syntax

```bash
$ awk options 'selection _criteria {action }' input-file > output-file
```

```bash
# Example
$ awk '{print $1}' < myfile.txt
```

* scans file line by line
* splits each input line into fields
* compares input line to pattern
* performs action on matched lines

```bash
\s*?(unsigned){0,1}\s*?int\s*?\w+\s*?\;\s*\/{0,3}.*
```

## Q5

### Test Cases:

1. Has .args, has .out
2. Has .args, does not have .out
3. Does not have .args, has .out
4. Does not have .args and does not have .out

   Questions:

   * cat: test3.out: No such file or directory message is still present

