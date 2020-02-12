### Committing/Pushing
```bash
$ git add .
$ git commit
$ git push
```

### Fix a commit
```bash
$ git commit -amend
```

### Reset to last git commit 
```bash
$ git reset --hard HEAD
# OR
$ git reset --hard
```

### Undo a commit without losing local files
```bash
git reset HEAD~1
```

### Commit specific lines of code
```bash
$ git add -p
>> Stage this hunk [y, n, ...]?
```
- Pick the chunks of code you do want to commit
- stage this hunk means are you gonna commit this?

#### Options for `Stage this hunk [y, n, ...]?`
- Press `?` if you want more info
- Press `n` to go to next change

**Note**: Does not work for new files
(i.e. if you do a `touch`, and try to do `git add -p` right after)

### Delete file that is already in repo
```bash
$ git rm <file-name> 
```
- If you want to delete this file that is already in the repo, use this to not commit file-name

### Show changes between commits
```bash
$ git diff
```
- when you do `y` for `git add -p`, `git diff` will be empty (obviously)

### Do not commit specific lines of code
```bash
$ git reset -p
```

## `.gitignore`
- Checking if something's really ignored
  - do `git status` and check if file still appears as red
- Ignoring all types of a file extension, folder, or file
  - `*.<file-extension>` (eg. txt, swp)
  - `*<folder/file-name>`