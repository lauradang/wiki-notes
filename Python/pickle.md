# Pickle

## Things you can Pickle

- `numpy` arrays
- Class objects

## Dumping Pickle

```python
import numpy as np
import pickle

X = np.array([0, 1, 2, 3, 4])
pickle_out = open(f"output.pkl", "wb")
pickle.dump(X, pickle_out)
pickle_out.close()
```

## Loading Pickle

```python
pickle_object = pickle.load(open("output.pkl", "rb"))
```

