# Jupyter Notify

```python
import jupyternotify
ip = get_ipython()
ip.register_magics(jupyternotify.JupyterNotifyMagics)

%load_ext jupyternotify

%%notify
import time
time.sleep(5)
```

