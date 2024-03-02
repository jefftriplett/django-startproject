set dotenv-load := false

compose := "docker compose run --rm --no-deps utility"

@_default:
    just --list

@_cog:
    pipx run --spec cogapp cog -r README.md

@_fmt:
    just --fmt --unstable

bootstrap *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ ! -f ".env" ]; then
        echo ".env created"
        cp .env-dist .env
    fi

    if [ ! -f "compose.override.yml" ]; then
        echo "compose.override.yml created"
        cp compose.override.yml-dist compose.override.yml
    fi

    python -m pip install --upgrade pip uv
    python -m uv pip install --upgrade pre-commit
    python -m uv pip install --upgrade --requirement requirements.in

    docker compose {{ ARGS }} build --force-rm

@build *ARGS:
    docker compose build {{ ARGS }}

@console:
    {{ compose }} /bin/bash

@down:
    docker compose down

@lint:
    python -m pre_commit run --all-files

@lock *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility \
            bash -c "python -m uv pip compile {{ ARGS }} ./requirements.in \
                --resolver=backtracking \
                --output-file ./requirements.txt"

@logs *ARGS:
    docker compose logs {{ ARGS }}

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

@pre-commit *ARGS:
    python -m pre_commit run {{ ARGS }} --all-files

@restart *ARGS:
    docker compose restart {{ ARGS }}

@start *ARGS="--detach":
    just up {{ ARGS }}

@stop:
    just down

@tail:
    just logs --follow

@test *ARGS:
    {{ compose }} pytest {{ ARGS }}

@up *ARGS:
    docker compose up {{ ARGS }}

@upgrade:
    python -m pip install --upgrade pip uv
    python -m uv pip install --upgrade pre-commit
    python -m uv pip install --upgrade --requirement requirements.in
    just upgrade
