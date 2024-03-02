set dotenv-load := false

compose := "docker compose run --rm --no-deps utility"
manage := compose + " python -m manage"

@_default:
    just --list

@build *ARGS:
    docker compose build {{ ARGS }}

# opens a console
@console:
    {{ compose }} /bin/bash

@fmt:
    just --fmt --unstable

@lint:
    python -m pre_commit run --all-files

@lock *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        web \
            bash -c "uv pip compile {{ ARGS }} ./requirements/requirements.in \
                --resolver=backtracking \
                --output-file ./requirements/requirements.txt"

@logs +ARGS="":
    docker compose logs {{ ARGS }}

@pip-compile *ARGS:
    python -m pip install --upgrade pip uv
    python -m uv pip install --upgrade -r requirements/requirements.in
    python -m pip compile {{ ARGS }}  \
        --resolver=backtracking \
        requirements/requirements.in

@pip-compile-upgrade:
    just pip-compile --upgrade

@pre-commit:
    python -m pre_commit run --config=.pre-commit-config.yaml --all-files
