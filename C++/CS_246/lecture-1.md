# Lecture 1

## Linux Shell
Shell: Interface to the OS
- gets OS to do stuff - run programs, manage files
- graphical shell (Windows, Mac OS, Ubuntu)
- command line (type commands - terminal)

In this course, we use Bash.
```bash
# type this to ensure you are in bash
$ echo $0
>> -bash
```

## Files, Input/Output
#### ```$ cat```
- Displays contents of root directory
- First slash denotes root directory (top of directory hierarchy)
```bash
$ cat /path/to/file
```

What if I just run :
- Copies output
- Is this useful?
  - Can capture output and put in a file
  -```cat > output.txt```
```bash
# Example
$ cat
hello
>> hello
hi
>> hi
```
Stopping cat from running: ```Ctrl+D```

## Text in Linux
In linux, every line in valid txt file must end with a newline character.
- Marmoset checks that last line ends in \n
- When printing output, should end in \n

## Terminating program
- For infinite loop or crash, to terminate program: ```Ctrl+C```

### ```$ ls```
- Displays file in current dir

### ```$ ls -a```
- Displays hidden files + files in current dir

### ```$ pwd```
- prints the current dir
- stands for present working directory

## Redirecting Output
- output redirection symbol: ```>```
- what would be printed to output, send to file
```bash
# Example:
$ cat args > file
```

## Redirecting Input
- input redirection symbol: ```<```
```bash
# Example:
$ cat < inputfile
```
- reads intput from file instead of keyboard
- in the case of ```$ cat```, the output is the same

## Difference in Behaviour
- **$ cat /file** -> pass "file" as an argument to cat which opens the file and prints it
- **$ cat < file** -> the **shell** opens the file and passes its content in place of keyboard input

## ```$ wc```
- line count, word count, character count


## Asterisk in Linux (*)
- *.txt is a globbing pattern 
- asterisk means match anything
- when shell sees globbing pattern, the shell expands globbing pattern to match non-hidden files
- More globbing patterns on reference sheet
- Many commands can accept arguments or input with the exception of ```$ echo```

```bash
# Example:
## Copies input.txt into output.txt
$ cat < input.txt > output.txt
```

```bash
# Example:
## Prints output preceeded by line numbers
$ cat -n < input.txt > output.txt
```
















