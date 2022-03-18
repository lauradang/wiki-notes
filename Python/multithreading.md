# Multithreading

## Python Global Interpreter Lock (GIL)

https://realpython.com/python-gil/
https://www.youtube.com/watch?v=6g79qGQo2-Q

### What is it?

A lock that allows only **1 thread** can be state of execution at any point in time.

It forces every thread that is Python-byte code (pure Python code, no C library, numpy, etc.) to acquire a shared lock first. The GIL will be dropped when doing I/O (reading and writing from DB or web requests) or when using non-pure Python code. There is one GIL per process (so all threads in a process share the lock while processes do not).

Can cause problems for multi-threading programs.

### Solution

Use multiprocessing instead. Note process managements has its own overheads and they are heavier than threads (this solution only applies if you are using pure Python - not calling a C library, numpy, etc.).

For some libraries, you can tell the library to remove the GIL.
