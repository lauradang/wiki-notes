# Docker Images

## Steps to create your own image

1. OS (ubuntu?)
2. Update `apt` repo
3. Install dependencies using `apt`
4. Install python dependencies with`pip`
5. Copy source code to `/opt` 
6. Run web server with Flask command

**Example**:

```dockerfile
FROM Ubuntu

RUN apt-get update
RUN apt-get install python

RUN pip install flask

COPY . /opt/source-code

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```



## Creating the Docker image with Poetry

```dockerfile
# Base image
FROM python:3.6

# Set "local docker" variable
ARG USE_PRODUCTION_ENV

# Set environment variable equal to the docker variable
ENV USE_PRODUCTION_ENV=$USE_PRODUCTION_ENV \
PYTHONFAULTHANDLER=1 \
PYTHONUNBUFFERED=1 \
PYTHONHASHSEED=random \
PIP_NO_CACHE_DIR=off \
PIP_DISABLE_PIP_VERSION_CHECK=on \
PIP_DEFAULT_TIMEOUT=100 \
PATH="/root/.poetry/bin:$PATH"

# Install Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# Install project dependencies
WORKDIR /api
COPY poetry.lock pyproject.toml /api/

# Set virtualenv False (See Note 1)
RUN poetry config virtualenvs.create false

# Installs dependencies (See Note 2)
RUN poetry install $(test "$USE_PRODUCTION_ENV" = "True" && echo "--no-dev") --no-interaction --no-ansi
RUN python -m spacy download en

# Copy entire project into container (Note 3)
WORKDIR /
COPY . /api/

# Run application server
CMD [ "gunicorn", "-w", "1", "-b", ":8000", "-t", "360", "--reload", "api.wsgi:app" ]
```

**Note 1**: Poetry creates a virtual environment automatically to isolate poetry installations from local, but Docker already does this, so we don't need a virtualenv to be created. So `virtualenvs.create` is set to `false`.

**Note 2**: `test` is an `if` statement in bash. So this means, "If $USE_PRODUCTION_ENV == True, then print --no-dev" in the shell command.

 Explicitly:

```bash
# If $USE_PRODUCTION_ENV == True, the shell command will look like this:
$ poetry install --no-dev --no-interaction -no-ansi
# If $USE_PRODUCTION_ENV == False, the shell command will look like this:
$ poetry install --no-interaction -no-ansi
```

**Note 3**: Must move back into root directory since we are presently in the `api` directory as we ran `WORKDIR /api`.

## Installing dependencies with Poetry and Docker

```python
docker-compose run api /bin/bash -c "cd /api && poetry add <dependency-name>"
```

- You can't just `docker exec -it api /bin/bash` into the container when you are missing a dependency because the Docker container would complain there is no module found, thus kicking you out of the bash terminal. This command disregards this because the docker service does not need to be **up** when using this command (still needs to be built though of course).

