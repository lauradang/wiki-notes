# Git command options

## `git-dir`

**DON'T FORGET THE `.git` AT THE END OF THE DIR PATH!!**

```bash
git --git-dir=path/to/git/dir/.git <git-command (e.g. log, commit, push, etc.)>
```

## `branch`

If the branch is remote (you did not fetch), then you have to append the branch name to `origin/`

```bash
git <git-command (e.g. log, commit, push, etc.)> origin/<BRANCH_NAME>
```

## `date`

Date options:

- iso-strict-local
- relative
- local
- iso
- short
- human

```bash
git <git-command> --date=<date_option>
```

## `pretty`

Format options:

- `%ad` (show date)
- `%ae` (show author)

```bash
git <git-command> --pretty=format:'<format_option>'
```

