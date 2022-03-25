# Multiprocessing

## `multiprocessing.Pool.map()`

[Data and Chunk Sizes Matter](https://rvprasad.medium.com/data-and-chunk-sizes-matter-when-using-multiprocessing-pool-map-in-python-5023c96875ef#:~:text=In%20Python%2C%20multiprocessing.,are%20returned%20as%20a%20collection)

`multiprocessing.Pool.map(f, c, s)`
- function `f`
- collection `c` of data items
- chunk size `s`

`f` is applied in parallel to items in `c` in chunks of `s` (results returned as collection)

## Optimal Chunk Size
 [multiprocessing: Understanding logic behind `chunksize`](https://stackoverflow.com/questions/53751050/multiprocessing-understanding-logic-behind-chunksize)

### Chunk

Share of the `collection/iterable`-argument specified in pool-method call

### Task

Think of it as processing done by a single worker

### Taskel

Processing done by a single worker of a chunk (a task consists of chunksize taskels)

### [Thrashing](https://en.wikipedia.org/wiki/Thrashing_(computer_science))

Occurs when computer's virtual memory resources are overused resulting in performance degradation/collapse. The situation can continue indefinitely until either the user closes some running applications or the active processes free up additional virtual memory resources.

### Parallelization Goals

- minimize parallization overhead (make sure tasks are computationally heavy enough to make up for the overhead)
- high utilization across all cpu-cores
- keeping memory usage limited to prevent OS from excessive paging (thrashing)

### Parallelization Scenarios

Keep in mind, overhead *weight* increases with shorter computation times per taskel.

**Dense Scenario**:
- all taskels need exactly same computation time
- **optimization strategy**:
    - distribute all taskels at once
    - so create only as much chunks as there are workers/processes
    - chunks should be equal size

**Wide Scenario**:
- a taskel could take seconds or days to finish
- **optimization strategy**:
    - distribute less taskels at once (help utilize all cores)

### Risks of chunk size > 1

Ex.1

Instead of the actual values, we pretend to see the needed computation time in seconds in the iterables.

`good_luck_iterable = [60, 60, 86400, 60, 86400, 60, 60, 84600]` with chunk size 2 and 4 workers would look like:

`[(60, 60), (86400, 60), (86400, 60), (60, 84600)]`

What if we switched the position of only one element?

`bad_luck_iterable = [60, 60, 86400, 86400, 60, 60, 60, 84600]`. The result would be:

`[(60, 60), (86400, 86400), (60, 60), (60, 84600)]`

Total processing time of `(86400, 86400)` becomes a lot larger..

If `chunksize=1`, we would never encounter such bad luck. This is the risks of bigger chunk sizes.

**Trade-off**: bigger chunk sizes = less parallelization overhead, but not always the best deal as seen in the case above.

## Mutexes

This also applies to non-Python multiprocessing.

**Situation**:

```python
if experiment_exists in db:
   mlflow.set_experiment(experiment_in_db)
else:
   insert_in_db(experiment)
   mlflow.create_experiment(experiment_in_db)
   mlflow.set_experiment(experiment_in_db)
```

Imagine we have two processes running at the exact same speed and so one of them hits the first if statement and checks the DB only to find there is no experiment that exists, then goes to the else. But then before process 1 gets to execute `insert_in_db(experiment)` (so the DB is still empty). Process 2 comes in and runs the first if statement only to find there's nothing in the DB, so then it moves onto the else . At this point, process 1 has executed `insert_in_db` so now the DB has something in it. But since process 2 is in the else, it will insert the exact same entry into the DB which results in a SQL duplicate entry error.

Is there a way to counter this?

Slack thread with Tayef :)

Tayef Shah  2:58 PM
> yes
> establish a critical section in your code.
> a critical section is a part of your code which at most one thread can be in at any given time.
> not sure what structure you can use in python, but you might wanna look into mutexes or semaphores

Laura Dang  2:59 PM
> does it make a diff that these are processes not threads

Tayef Shah  3:00 PM
> yeah, for processes I think only mutexes will work
> general structure is kinda like this

```python
mutex.lock()
  if condition:
     do stuff
   else:
     do other stuff
mutex.unlock()
```
Here's a Python solution for this: https://stackoverflow.com/questions/70551771/what-is-the-correct-way-to-handle-a-mutex-like-lock-for-a-mpi4py-function-call.
