# Lecture 4

### For Loop Exampled ctd.
**How many times does the word ${1} occur in file ${2}?**
```bash
#!/bin/bash
x=0

for word in $(cat ${2}); do
  if [$word=${1}]; then
    x=$((x+1))
  fi
done

echo ${x}
```

**Payday is last Friday of month. Write script to tell what day we will get paid this month.**
```bash
$ cal 1 awks '{print $6}' | egrep "[0-9]" | tail -1
```
```bash
#!/bin/bash

report() {
  if [${1} -eq 31]; then
    echo "Payday is the 31st"
  else
    echo "Payday is the ${1}th"
  fi
}

report $(cal 1 awks '{print $6}' | egrep "[0-9]" | tail -1)
```