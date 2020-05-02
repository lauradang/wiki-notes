# Docker-compose.yml

## Example Docker Compose

```yaml
version: "3"

services:
  app: # SERVICE name
    container_name: test-app 
    restart: always
    build:
        context: ./app
        args:
          - TEST_ARG # Build argument
    ports:
      - "8000:8000"
    expose:
      - "8000"
    depends_on:
      - db
    volumes:
      - "./app:/app"
  db: # SERVICE name
    container_name: ml-db
    image: mysql:5.6
    volumes:
      - "dbdata:/var/lib/mysql"
    environment:
      - "MYSQL_USER=user"
      - "MYSQL_PASSWORD=password"
      - "MYSQL_ROOT_PASSWORD=password"
      - "MYSQL_DATABASE=db"
    ports:
      - "33061:3306"
    expose:
      - "3306"

volumes:
  dbdata:
```

## Setting up database in Docker
### Environment in yaml file:
- Tied with config file
- In the config file, all the environment variables are set
- Then you can use config file in Flask SQL connector

## Running a project that uses Docker Compose

```bash
$ cd docker_compose_file_location
$ docker-compose build
$ docker-compose up
```

## Running a project that uses Docker Compose build arguments

The build argument is defined in the `docker-compose.yml` file under `args`

```bash
$ cd docker_compose_file_location
$ docker-compose build --build-arg TEST_ARG=True service-name1 service-name2 ..
$ docker-compose up
```

## Seeding a database with a SQL file in Docker Compose

```bash
$ cd docker_compose_file_location
$ docker-compose build 
$ docker-compose up db # The database service name
$ docker-compose exec -T db mysql -u user -p password < setup.sql
```

## Running a command without a Docker container being up

```bash
$ docker-compose run --rm service_name ./test.sh
```

This is especially useful with continuous integration testing like Travis CI. Here is an example:

```yaml
# .travis.yml
language: python
services: docker
python:
    - 3.6

before_install:
    - docker-compose build

script:
    - docker-compose run --rm api ./utils/test.sh
```