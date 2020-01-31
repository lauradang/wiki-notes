# Lecture 2

#### Stderr
- Where we expect error messages
- Unbuffered stream (information is printed immediately)
- Make sure error message doesn't get mixed up with output
- To redirect: 
```bash
$ 2 > file.txt
```

**How many words occurs in first 20 lines of file.txt?**
```bash
$ head -n 20 file.txt > temp
$ wc -w < temp > output.txt
```

#### Pipeline
```bash
# Takes output from cmd before and redirects it as input in second command
$ head -n 20 file.txt | wc -w > output.txt
```

**Suppose words.txt, words2.txt, etc. each contains a list of words, one per line. Produce a duplicate-free list of all words that occur.**
```bash
$ cat words*.txt | 
```
#### ```$ sort```
- sorts lines in lexicographical order

#### ```$ uniq``` 
- removes adjacent duplicate lines
- -c counts occurrences adjacent lines

**Can we use output from a program as an argument to another program?**
- files.txt contains a list of files on one line
- We want to use that list of files as arguments to a program
```bash
# counts num of chars, words, lines present in file.txt
$ cat file.txt | wc
```

```bash
# wc of 2 files cat, file.txt
$ wc cat file.txt 
```

#### Embedded Command
```bash
$ (command args...)
# eg.
$ wc $(cat file.txt)
```

```bash
# Double quotes suppress globbing pattern
$ echo "Today is $(date). I am $(whoami)"
>> Today is Sep 10 13:30:21 EDT 2019.. I am lauradang.

# Single quotes suppress all embedded commands (prints echo exactly as echo was typed)
$ echo 'Today is $(date). I am $(whoami)'
>> Today is $(date). I am $(whoami)

# can also do no quotes
$ echo Today is $(date). I am $(whoami). *.txt
```
### How to find words or patterns in a file 
#### ```$ egrep``` 
- extended global regular express print
```bash
# General Form:
$ egrep pattern file (can be a list of files)

# Example:
$ egrep cs246 file.txt
>> Prints all lines containing cs246

$ egrep "cs246|CS246" file.txt
>> Print every line that contains cs246 or CS246

# Find | in a file or another special symbol
>> egrep "\|" in file.txt
```
#### More Pattern Rules
- **(pattern)** groups contents together
- **[chars]** match one instance of any character
  - eg. ```[a-z]``` matches any of a-z
  - don't do ```[A-z]``` to get all of alphabet (looks for ASCII between capital letters and lowercase letters)
- **[^chars]** matches anything except these characters
- **?** : previous pattern occurs 0 or 1 times
    - eg. ```[Cc][Ss] ?246``` (don't know if ppl do CS246 or CS 246)
- **\*** : 0 or more occurrences of preceeding pattern 
  - (cs)*246 matches: 246, cs246, cscs246, cscscs246, etc.
  
- **+** : 1 or more occurrences of preceeding patern
- **.** : match one instance of any character
- **.*** : match 0 or more instances of ny char
- **^** : matches beginning of line
  - eg. ```^cs246``` (must begin with cs246)
- **$** : matches end of line
  - eg. ```cs246$``` (must end with cs246)

**Example: Find lines of even length**
```bash
^(..)*$
```

#### ```ls -l```
- Shows "long" form of files
```bash
$ ls -l
# type/permission owner group   size (last modified date) name
>> -rw-r--r-- 1 name name   0 Sep 10 13:32 hello.txt

# r -> read
# w -> write
x -> execute
```




