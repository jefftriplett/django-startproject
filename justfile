set dotenv-load := false

# Show list of available commands
@_default:
    just --list

# Generate README content with cogapp
@_cog:
    uv run --with cogapp cog -r README.md

# Format justfile with unstable formatter
@_fmt:
    just --fmt --unstable

# Initialize project with dependencies and environment
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

# Build Docker containers with optional args
@build *ARGS:
    docker compose build {{ ARGS }}

# Open interactive bash console in utility container
@console:
    docker compose run --rm --no-deps utility /bin/bash

# Stop and remove containers, networks
@down *ARGS:
    docker compose down {{ ARGS }}

# Run pre-commit hooks on all files
@lint *ARGS:
    uv run --with pre-commit-uv pre-commit run {{ ARGS }} --all-files

# Compile requirements.in to requirements.txt
@lock *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility \
            bash -c "uv pip compile {{ ARGS }} ./requirements.in \
                --output-file ./requirements.txt"

# Show logs from containers
@logs *ARGS:
    docker compose logs {{ ARGS }}

# Run Django management commands
@manage *ARGS:
    docker compose run --rm --no-deps utility python -m manage {{ ARGS }}

# Dump database to file
@pg_dump file='db.dump':
    docker compose run \
        --no-deps \
        --rm \
        db pg_dump \
            --dbname "${DATABASE_URL:=postgres://postgres@db/postgres}" \
            --file /src/{{ file }} \
            --format=c \
            --verbose

# Restore database dump from file
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

# Restart containers
@restart *ARGS:
    docker compose restart {{ ARGS }}

# Run command in utility container
@run *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility {{ ARGS }}

# Start services in detached mode by default
@start *ARGS="--detach":
    just up {{ ARGS }}

# Stop services (alias for down)
@stop *ARGS:
    just down {{ ARGS }}

# Show and follow logs
@tail:
    just logs --follow

# Run pytest with arguments
@test *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility python -m pytest {{ ARGS }}

# Start containers
@up *ARGS:
    docker compose up {{ ARGS }}

# Upgrade dependencies and lock
@upgrade:
    just lock --upgrade
