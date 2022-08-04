# I/O

## Persistent Disk Benchmarking

[Benchmarking persistent disk performance](https://cloud.google.com/compute/docs/disks/benchmarking-pd-performance)

[fio](https://linux.die.net/man/1/fio)

## Buffered I/O vs. Unbuffered I/O

https://stackoverflow.com/questions/1450551/buffered-vs-unbuffered-io

- **Buffered I/O:** program structures -> file buffer -> kernel buffer -> disk
    - minimizes system calls
    - minimizes disk I/O

- **Unbuffered I/O:** program structures -> kernel buffer -> disk
    - Used when we want output to be written before continuing (e.g. stderr under C runtime library is usually unbuffered by default, logging library)

**Example**:

- Program reads file 1 byte at a time
- Unbuffered input: goes to disk for every byte (slow)
- Buffered input: Whole block is read into buffer, then individual bytes delivered from buffer area (faster)
