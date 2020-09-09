# Docker Commands

**Note**: When typing any Docker container ID, you don't have to type the whole thing, just the necessary number of characters that will differentiate the container from others.

## Start a Container

```bash
docker run ansible
docker run mongodb
... # This runs container in the foreground (attached to stdout of container and you will see output)

docker run -d <repo-name>
# this runs container in the background (detached, won't see output)

docker run <image-name>:<version> # ex. docker run redis:4.0 (called a tag)

docker run --name webapp ansible # Name conainer webapp
```

## List Running Containers

```bash
docker ps
docker ps -a # Previously exited containers too
```

## Stop Container

```bash
docker stop <container_id>
docker stop <container_name>
```

## Remove Container

```bash
docker rm <container_id>
docker rm <container_name>

# Run docker ps -a to see if it's truly gone
```

## List Images

```bash
docker images
```

## Remove Images

```bash
docker rmi <image_name> # ex. docker rmi nginx
# MUST DELETE ALL DEPENDENT CONTAINERS FIRST
```

##  Download an Image (Doesn't run container)

```bash
docker pull <image_name> # ex. docker pull nginx
```

## Executing a command on the container

```bash
docker exec <container_name> <command> # ex. docker exec silly_samet cat /etc/hosts
```

## Attach

```bash
docker attach <container_id>
docker attach <container_name>
```

## Interactive Mode

```bash
# When you need STDIN or to interact with the container
docker run -i <repo> # will not show user input prompt though
docker run -it <repo> # for STDIN and showing prompt (we attach ourselves to the docker container's terminal)
```

## Inspect Containers

```bash
# Shows environmental variables of container and other information 
docker inspect <container_name>
```

## Container Logs

```bash
docker logs <container_name>
```

## Set Environment Variables

```bash
docker run -e ENV_VAR=blue <image_name>

# Adding password to SQL database
docker run -e MYSQL_ROOT_PASSWORD=<password> mysql
```

## Build Image

```bash
docker build -t <image_name> /directory/to/Dockerfile # Creates image based off of your Dockerfile locally
# e.g. docker build -t webapp .

docker build <dockerfile_name> -t <image_name>
```

## Publish Image

```bash
docker push <image_name>
```

## See Image build history

```docker
docker history <image_name>
```

