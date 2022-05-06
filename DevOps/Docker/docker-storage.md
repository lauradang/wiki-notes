# Docker Storage

## Device out of space

try this: https://code-examples.net/en/q/2335473

Cleanup exited processes:

```bash
docker rm $(docker ps -q -f status=exited)
```

Cleanup dangling volumes:

```bash
docker volume rm $(docker volume ls -qf dangling=true)
```

Cleanup dangling images:

```bash
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
```
