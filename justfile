set dotenv-load := false

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

    just upgrade

    just build {{ ARGS }} --force-rm

@build *ARGS:
    docker compose build {{ ARGS }}

@console:
    docker compose run --rm --no-deps utility /bin/bash

@down *ARGS:
    docker compose down {{ ARGS }}

@lint *ARGS:
    python -m pre_commit run {{ ARGS }} --all-files

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
    docker compose run --rm --no-deps utility {{ ARGS }}

@start *ARGS="--detach":
    just up {{ ARGS }}

@stop *ARGS:
    just down {{ ARGS }}

@tail:
    just logs --follow

@test *ARGS:
    docker compose run --rm --no-deps utility python -m pytest {{ ARGS }}

@up *ARGS:
    docker compose up {{ ARGS }}

@upgrade:
    just lock --upgrade
