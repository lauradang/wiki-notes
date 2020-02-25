# Lecture 3
### ```chmod mode file```
- Changes file permissions
- Mode consists of 3 parts:
  - **user type**
    - u = user
    - g = group
    - o = other
  - **operator**
    - '+' = add this permission
    - '-' = remove this permission
    - '=' = set permission exactly
  - **Permission**
    - 'r' = read bit
    - 'w'= write bit
    - 'x' = execute bit

### ```chmod otr file```
- Gives others permisison to read

### ```chmod oug=rw file```
- Make everyone's permission read and write (not execute)

### ```chmod u=r file.txt```

## Shell Scripts
- File that contains a series of commands that we will execute as a program
- eg. print date, current user, current directory

```bash
# Make script
$ vi firstScript.sh

#!/bin/bash
date
whoami
pwd

# Run script (. means current directory, / is before name of directory)
$ ./firstScript.sh
>> May get permission error (do ls -l to check permissions)

# if permission error:
$ chmod oug=x firstScript.sh
```

### Variables 
- name=value (notice there are no spaces)
  - assigns value to variable
  - eg. ```x=1``` and ```x =1``` are different in bash
- ${varname} 
  - retrieves data stores in variable
  - eg. ```$x```
  - do not use ```$``` when assigning variables 
  - Good practice: ```${x}```
  - eg. ```echo "The cost is ${x}USD"```
- Command line args are stored ```$1, $2, $3```

In bash, all variables are **strings**.
- Double quotes
  - allow variable expansion
- Single quotes
  - supresses variable expansion
```bash
$ vi firstScript.sh

# Add variable to script
#!/bin/bash
Command line arg: ${1}

$ ./firstScript.sh hello
>> Command line arg: hello

$ ./firstScript.sh "hello world"
>> Command line arg: hello world
```

### ```if``` Statement Format
```bash
if [ $? -eq 0 ]; then
  ...
elif [$? -eq 1 ]; then
  ...
else
  ...
fi
```

#### Example: Check if argument is in dictionary
```bash
#!/bin/bash
egrep "^1${1}$" /usr/share/dict/words
```
Print ```${1}``` if it's a word in the dictionary. Otherwise, does nothing.

#### Example: A 'good' password should not be in the dictionary. Answer whether a word is a good password.

##### First way to do it:
```bash
#!/bin/bash
egrep "^${1}$" /usr/share/dict/words > /dev/null
# Note: redirecting stdout to /dev/null suppresses output

# semi colon indicates you want more than 1 commands on 1 line
# then is a command (can be on the second line, then there is no need for ;)
if [ $? -eq 0 ]; then # need a space before and after square bracket
  echo "Bad password"
else
  echo "Maybe a good password"
fi
```
##### Second way to do it:
```bash
#!/bin/bash
usage() {
  echo "Usage: $0 password"
} # $0 stores the name of the program

# -ne is not equal
if [ $# -ne 1 ]; then
  usage # function call (looks like cmd)
  exit 1
fi
```


##### Every program returns a status code
- egrep returns 0 if a match is found, 1 if not found
- In Unix: 0 is success, non-zero is failure
- ? stores status of most recently executed command
```bash
$ echo $? 
# if most recently executed command was a failure
>> 1

$ echo $?
# if most recently executed command was a success
>> 0
```
### Syntax for doing math
```bash
$((...))
```
### Bash Loops
##### Example: Print numbers from 1 to ${1}
```bash
#!/bin/bash
x=1

# -le is less than or equal to
while [ $x -le ${1} ]; do
  echo ${x}
  x=$((x+1)) 
done
```
### Bash For loops
```bash
#!/bin/bash
# abc is an arbitrary list
for x in abc; do
  echo ${x}
done

for file in *; do
  ...
done
```
```bash
# Rename all .cpp files to .cc
#!/bin/bash
for file in *.cpp; do
  # mv renames files
  mv ${file} ${file % cpp} cc
done
```

