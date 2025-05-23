# Git Merge Conflicts

### Merging big code change on small code change
1. Make a temporary copy branch of the branch with a smaller code change
```bash
$ git checkout small-code-change
$ git checkout -b temp/small-code-change
```
2. Go back to branch with the small code change and reset (if the small code change branches from the big code change) it to look like the branch with a big code change (**Basically make your smaller code look exactly like your bigger code**) - Remember the changes you made in the smaller code is copied in the temporary branch above
```bash
$ git checkout small-code-change
$ git reset --hard origin/big-code-change
```
3. Now merge the temporary copy branch, `temp/small-code-change`, into `small-code-change` (This may take some manual copy paste depending on how big the merge conflict is).
```bash
(small-code-change) $ git merge temp/small-code-change
```

## Squashing merges

`git rebase -i master`
