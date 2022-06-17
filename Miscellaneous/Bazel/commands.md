# Commands

## Run with pdb debugger
```bash
# Run `whereis python3.8` or `which python3.8` to find pdb.py location

bazel run --run_under="/usr/lib/python3.8/pdb.py" ... $@
```
