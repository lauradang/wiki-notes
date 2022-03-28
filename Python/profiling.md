# Profiling

For simpler programs, you can resort to using cProfile and [vprof](https://github.com/nvdv/vprof). However, these fail when running multithreading/multiprocessing programs since these profilers only profile the parent process, not the child processes.

## Multiprocessing

[py-spy](https://github.com/benfred/py-spy) can be used to profile individual processes.

Here's my process when using it:

1. Launch program (put a `import time; time.sleep(60)` right after the child processes are launched to give yourself time to put in the `py-spy` commands. **If it's a long program, remember to use tmux**.

2. In another terminal session, launch `htop`.

3. Identify the PID's of the child processes.

4. Open $$n$$ more terminal sessions and put `py-spy record -o profile.svg --pid 12345`

5. **Optional**: You can also monitor the processes in real-time by running `py-spy top --pid 12345`
