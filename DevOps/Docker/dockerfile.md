# Dockerfile
ALWAYS FOLLOWS THIS FORMAT: `INSTRUCTION` `ARGUMENT` 

### `FROM`
  - Inherits and sets Base Image (like Base class) or OS
  - eg. `python:3.6`
    - `3.6` is the tag/version

### `RUN apt-get update`
- Runs this linux command and downloads all OS package related updates in the container

### `COPY ./<your-directory> /<your-directory>`
- Copies local folder into the container's folder
  - i.e. `./app` in local folder copies to container's `/app`
- For local folder, the `.` is the same directory as the Dockerfile

### `WORKDIR`
- Starts container in thie `workdir` directory
  - i.e. 
    - `mkdir workdir`
    - `cd workdir`

**Note**: These 2 ways are equivalent:

```bash
COPY ./api /api
WORKDIR /api
```
```bash
WORKDIR /api # makes work directory and cds into it
COPY . . # then you are already in the folder, so you can just use a .
```
### `ENV`
- Sets environment variable (global variable in shell) in the container
- Will do `export MYSQL_USER=ml`

### `CMD`
- Command at startup of container (if there is another command in `docker run...`, this command replaces the one in the Dockerfile)

### `ENTRYPOINT`

- Command at startup of container (if there is another command in `docker run...`, this command is APPENDED to the one in the Dockerfile)

### Using both `CMD` and `ENTRYPOINT`

You do this when you want a default command, but the argument can be changed

```dockerfile
FROM Ubuntu

ENTRYPOINT ["sleep"]

CMD ["5"]
```

So here, if no parameter is specified in `docker run...` , then `sleep 5` will run. Otherwise, `sleep <argument>` will run.

### `colon :`
- This means port
- If you do `google:80`, just goes to google
  - 80 is the default port for websites
- 22 is the default port for ssh

### `gunicorn`
- `-w #` Tells you number of CPU cores/threads (1 CPU core handles 1 request at a time)
- `-b :#`: bind to port # of container
- `-t #`: timeout in seconds

## Formatting
These are all equivalent:
**Array**: `RUN/CMD/... [a, b, c, d]`
**Shell**: `RUN/CMD/... a b c d`

## Running commands inside a Docker container

```bash
# Running bash inside container
$ docker exec -it container_name /bin/bash

# Running command without being inside container
$ docker exec container_name <command>
```

## Caching

Caching when building Docker images can be very useful as it saves a lot of time when installing dependencies. 

**In what cases do Docker commands not use their cache?**

- If the contents that the command is applying itself on changes. 

  - e.g. `COPY ./example /copy` . If `./example` is changed in any way, this line in the Dockerfile will not use the cache.

- If anything before the command is installed/changed that wasn't installed/changed before.

  ```dockerfile
  # Dockerfile before
  RUN apt-get update
  COPY ./example /copy
  
  # Dockerfile after
  RUN apt-get update && apt-get -y install cron # A new package is being installed here
  COPY ./example /copy # This line will not use its cache
  ```

## Running another program before starting container

```dockerfile
# The bash script will call a program: e.g. python3 api/example.py
COPY download.sh /usr/local/bin/download.sh
RUN chmod +x /usr/local/bin/download.sh

WORKDIR /
CMD [ "/bin/sh", "-c", "/usr/local/bin/download.sh && gunicorn -w 3 -b :8000 -t 360 --reload api.wsgi:app" ]
```