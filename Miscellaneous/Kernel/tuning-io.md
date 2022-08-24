# Tuning I/O

https://medium.com/@duhroach/right-disk-type-for-performance-b1da856d087d

https://documentation.suse.com/sles/12-SP4/html/SLES-all/cha-tuning-io.html#:~:text=MQ%2DDEADLINE%20is%20a%20latency,same%20set%20of%20tunable%20parameters

## Check for scheduler

Run
```bash
grep . /sys/block/sd*/queue/scheduler
```

Can be one of:
- cfq
- noop
- deadline

### CFQ (Completely Fair Queuing)
- Each thread gets fair share of I/O throughput

### noop
- only passes down the I/O that comes to it
- Used for device setups that do I/O scheduling themselves

### Deadline
- each I/O request is assigned a deadline
typical: requests stored in queues (read and write) sorted by sector numbers

deadline: has 2 additional queues (read and write) in which requests are stored by deadline