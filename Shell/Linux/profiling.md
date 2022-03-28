# Profiling

To monitor CPU usage on your Linux machine, these are some tools I've been using

## `htop`

Enter `htop` into your terminal :)

## Procpath

This tool is great for creating visualizations of your CPU usage for specific processes.

Source: https://gist.github.com/brainsiq/4ce670e39494c962c5cbb95503732ec4

```bash
# Install procpath tool (use "python3 -m site --user-base" to find installation directory if needed)
pip3 install procpath

# Get the right version of sqlite
pip3 install apsw-wheels

# Start recording metrics
# i 5 - one datapoint every 5 seconds
# r 120 - 120 datapoints (omit r for continuous capture, and use ctrl+c to stop)
# d db.sqlite - a sqlite database
procpath record -i51 -r 120 -d db.sqlite '$..children[?(@.stat.pid == 42)]'
# can also do '$..children[?(@.stat.pid in [8667, 8668, 8669, 8670])]'

# Create graph
# p 42 - the same process id from record command
# -f img.svg - the name of the graph SVG
procpath plot -d db.sqlite -q cpu -p 42 -f img.svg
```
