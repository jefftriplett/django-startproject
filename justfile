set dotenv-load := false

@_default:
    just --list

@_cog:
    uv run --with cogapp cog -r README.md

@_fmt:
    just --fmt --unstable

bootstrap *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ ! -f ".env" ]; then
        cp .env-dist .env
        echo ".env created"
    fi

    if [ -n "${VIRTUAL_ENV-}" ]; then
        python -m pip install --upgrade pip uv
    else
        echo "Skipping pip steps as VIRTUAL_ENV is not set"
    fi

    if [ ! -f "requirements.txt" ]; then
        uv pip compile requirements.in --output-file requirements.txt
        echo "requirements.txt created"
    fi

    just upgrade

    if [ -f "compose.yml" ]; then
        just build {{ ARGS }} --pull
    fi

@build *ARGS:
    docker compose build {{ ARGS }}

@console:
    docker compose run --rm --no-deps utility /bin/bash

@down *ARGS:
    docker compose down {{ ARGS }}

@lint *ARGS:
    uv run --with pre-commit-uv pre-commit run {{ ARGS }} --all-files

@lock *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility \
            bash -c "uv pip compile {{ ARGS }} ./requirements.in \
                --output-file ./requirements.txt"

@logs *ARGS:
    docker compose logs {{ ARGS }}

@manage *ARGS:
    docker compose run --rm --no-deps utility python -m manage {{ ARGS }}

# dump database to file
@pg_dump file='db.dump':
    docker compose run \
        --no-deps \
        --rm \
        db pg_dump \
            --dbname "${DATABASE_URL:=postgres://postgres@db/postgres}" \
            --file /src/{{ file }} \
            --format=c \
            --verbose

# restore database dump from file
@pg_restore file='db.dump':
    docker compose run \
        --no-deps \
        --rm \
        db pg_restore \
            --clean \
            --dbname "${DATABASE_URL:=postgres://postgres@db/postgres}" \
            --if-exists \
            --no-owner \
            --verbose \
            /src/{{ file }}

@restart *ARGS:
    docker compose restart {{ ARGS }}

@run *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility {{ ARGS }}

@start *ARGS="--detach":
    just up {{ ARGS }}

@stop *ARGS:
    just down {{ ARGS }}

@tail:
    just logs --follow

@test *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility python -m pytest {{ ARGS }}

@up *ARGS:
    docker compose up {{ ARGS }}

@upgrade:
    just lock --upgrade
