# Writing Scripts in Python

## Argparse

The `argparse` library is useful for helping users run your script. Here is an example.

```python
# test.py
import argparse

arg_parser = argparse.ArgumentParser(description="A script to demonstrate argparse.")
arg_parser.add_argument("csv_filename", type=str, help="A comma-separated value file.")
arg_parser.add_argument("--index_column_exists", action="store_true", help="Including this argument indicates that the CSV already has an index column.")
args = arg_parser.parse_args()

if args.index_column_exists:
    df = pd.read_csv(args.csv_filename, index_col=0)
else:
    df = pd.read_csv(args.csv_filename)
```

### Running the script

To see how to run the script, run `python3 test.py -h`

