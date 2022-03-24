# Processes

## See threads in a process

```bash
pstree -halp <pid>
```

## Monitoring Processes

This commands allows you to see the CPU usage of each core on your machine:

```bash
watch -n 0.5 ps -ur
```

### `htop`

https://unix.stackexchange.com/questions/10362/why-does-htop-show-more-process-than-ps
TLDR: Turn off threads as procceses by pressing 'H' in `htop`.
