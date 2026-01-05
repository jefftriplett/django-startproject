set dotenv-load := false

# Show list of available commands
@_default:
    just --list

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

    if [ ! -f "uv.lock" ]; then
        just lock
        echo "uv.lock created"
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
    docker compose run \
        --no-deps \
        --rm \
        utility /bin/bash

# Open interactive bash console in database container
@console-db:
    docker compose run \
        --no-deps \
        --rm \
        db /bin/bash

# Stop and remove containers, networks
@down *ARGS:
    docker compose down {{ ARGS }}

# Format justfile with unstable formatter
[private]
@fmt:
    just --fmt --unstable

# Run pre-commit hooks on all files
@lint *ARGS:
    uv --quiet tool run prek {{ ARGS }} --all-files

# Update pre-commit hooks to latest versions
@lint-autoupdate *ARGS:
    uv --quiet tool run prek autoupdate

# Lock dependencies with uv
@lock *ARGS:
    uv lock {{ ARGS }}

# Show logs from containers
@logs *ARGS:
    docker compose logs {{ ARGS }}

# Create Django database migration files
@makemigrations *ARGS:
    just manage makemigrations {{ ARGS }}

# Run Django management commands
@manage *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility \
            uv run -m manage {{ ARGS }}

# Apply Django database migrations
@migrate *ARGS:
    just manage migrate {{ ARGS }}

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

# Pull Docker images
@pull *ARGS:
    docker compose pull {{ ARGS }}

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

# Stop services
@stop *ARGS:
    docker compose stop {{ ARGS }}

# Show and follow logs
@tail:
    just logs --follow

# Run pytest with arguments
@test *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility uv run pytest {{ ARGS }}

# Start containers
@up *ARGS:
    docker compose up {{ ARGS }}

# Update dependencies and pre-commit hooks
@update:
    just upgrade
    just lint-autoupdate

# Upgrade dependencies and lock
@upgrade:
    just lock --upgrade

# Watch for file changes and rebuild Docker services
@watch *ARGS:
    docker compose watch {{ ARGS }}
