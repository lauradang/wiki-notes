# Dockerfile
- **Relate to Object-oriented concepts**

### `FROM`
  - Inherits and sets Base Image (like Base class)
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
- Kind of the same as run, but is used when it's at the end of the Dockerfile

### `colon :`
- This means port
- If you do `google:80`, just goes to google
  - 80 is the default port for websites
- 22 is the default port for ssh

### `gunicorn`
- `-w #` Tells you number of CPU cores (1 CPU core handles 1 request at a time)
- `-b :#`: bind to port # of container
- `-t #`: timeout in seconds

## Formatting
These are all equivalent:
**Array**: `RUN/CMD/... [a, b, c, d]`
**Shell**: `RUN/CMD/... a b c d`










