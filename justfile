set dotenv-load := false

compose := "docker compose run --rm --no-deps utility"
manage := compose + " python -m manage"

@_default:
    just --list

@_cog:
    pipx run --spec cogapp cog -r README.md

bootstrap *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ ! -f ".env" ]; then
        echo ".env created"
        cp .env.example .env
    fi

    if [ ! -f "docker compose.override.yml" ]; then
        echo "docker compose.override.yml created"
        cp docker compose.override.yml-dist compose.override.yml
    fi

    docker compose {{ ARGS }} build --force-rm

    python -m uv pip install --upgrade pre-commit
    python -m uv pip install --upgrade --requirement requirements.in

@build *ARGS:
    docker compose build {{ ARGS }}

@console:
    {{ compose }} /bin/bash

@down:
    docker compose down

@fmt:
    just --fmt --unstable

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

@logs +ARGS="":
    docker compose logs {{ ARGS }}

# dump database to file
pg_dump file='db.dump':
    docker compose run \
        --no-deps \
        --rm \
        db \
        pg_dump \
            --dbname "${DATABASE_URL:=postgres://postgres@db/postgres}" \
            --file /src/{{ file }} \
            --format=c \
            --verbose

# restore database dump from file
pg_restore file='db.dump':
    docker compose run \
        --no-deps \
        --rm \
        db \
        pg_restore \
            --clean \
            --dbname "${DATABASE_URL:=postgres://postgres@db/postgres}" \
            --if-exists \
            --no-owner \
            --verbose \
            /src/{{ file }}

@pip-compile *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility \
            bash -c "python -m uv pip compile {{ ARGS }} ./requirements.in \
                --resolver=backtracking \
                # --generate-hashes \
                --output-file ./requirements.txt"

    # python -m pip install --upgrade pip uv
    # python -m uv pip install --upgrade -r requirements.in
    # python -m pip compile {{ ARGS }}  \
    #     --resolver=backtracking \
    #     requirements.in

@pip-compile-upgrade:
    just pip-compile --upgrade

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

@watch *ARGS:
    docker compose watch {{ ARGS }}
