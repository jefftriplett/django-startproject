<h1 align="center">Welcome to django-startproject 👋</h1>
<p>
  <a href="https://github.com/jefftriplett/django-startproject/actions" target="_blank">
    <img alt="CI" src="https://github.com/jefftriplett/django-startproject/workflows/CI/badge.svg" />
  </a>
</p>

> Django startproject template with batteries

## :triangular_flag_on_post: Features

- Django 5.0
- Python 3.12
- Docker Compose
- django-click
- environs[django]
- pre-commit
- psycopg2-binary
- whitenoise

### :green_heart: CI

- django-test-plus
- model-bakery
- pytest
- pytest-cov
- pytest-django

### 🏠 [Homepage](https://github.com/jefftriplett/django-startproject)

## :wrench: Install

```shell
$ django-admin startproject \
    --extension=ini,py,toml,yaml,yml \
    --template=https://github.com/jefftriplett/django-startproject/archive/main.zip \
    example_project
```

## :rocket: Usage

```shell
# Bootstrap our project
$ just bootstrap

# Build our Docker Image
$ just build

# Run Migrations
$ just manage migrate

# Create a Superuser in Django
$ just manage createsuperuser

# Run Django on http://localhost:8000/
$ just up

# Run Django in background mode
$ just start

# Stop all running containers
$ just down

# Open a bash shell/console
$ just console

# Run Tests
$ just test

# Re-build PIP requirements
$ just lock
```

## just support

<!-- [[[cog
import subprocess
import cog

help = subprocess.run(['just', '--summary'], stdout=subprocess.PIPE)

for command in help.stdout.decode('utf-8').split(' '):
    command = command.strip()
    cog.outl(
        f"- [{command}](#{command})"
    )
]]] -->
- [bootstrap](#bootstrap)
- [build](#build)
- [console](#console)
- [down](#down)
- [lint](#lint)
- [lock](#lock)
- [logs](#logs)
- [manage](#manage)
- [pg_dump](#pg_dump)
- [pg_restore](#pg_restore)
- [pre-commit](#pre-commit)
- [restart](#restart)
- [run](#run)
- [start](#start)
- [stop](#stop)
- [tail](#tail)
- [test](#test)
- [up](#up)
- [upgrade](#upgrade)
<!-- [[[end]]] -->

<!-- [[[cog
import subprocess
import cog

summary = subprocess.run(['just', '--summary'], stdout=subprocess.PIPE)

for command in summary.stdout.decode('utf-8').split(' '):
    command = command.strip()
    cog.outl(
        f"### {command}\n"
    )
    cog.outl(
        "<details>\n"
        "<summary>\n"
        "<code>\n"
        f"$ just {command}\n"
        "</code>\n"
        "</summary>\n"
    )
    command_show = subprocess.run(['just', '--show', command], stdout=subprocess.PIPE)
    cog.outl(
        f"```shell\n{command_show.stdout.decode('utf-8')}```\n"
        "</details>\n"
    )
]]] -->
### bootstrap

<details>
<summary>
<code>
$ just bootstrap
</code>
</summary>

```shell
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
```
</details>

### build

<details>
<summary>
<code>
$ just build
</code>
</summary>

```shell
@build *ARGS:
    docker compose build {{ ARGS }}
```
</details>

### console

<details>
<summary>
<code>
$ just console
</code>
</summary>

```shell
@console:
    docker compose run --rm --no-deps utility /bin/bash
```
</details>

### down

<details>
<summary>
<code>
$ just down
</code>
</summary>

```shell
@down:
    docker compose down
```
</details>

### lint

<details>
<summary>
<code>
$ just lint
</code>
</summary>

```shell
@lint:
    python -m pre_commit run --all-files
```
</details>

### lock

<details>
<summary>
<code>
$ just lock
</code>
</summary>

```shell
@lock *ARGS:
    docker compose run \
        --no-deps \
        --rm \
        utility \
            bash -c "python -m uv pip compile {{ ARGS }} ./requirements.in \
                --resolver=backtracking \
                --output-file ./requirements.txt"
```
</details>

### logs

<details>
<summary>
<code>
$ just logs
</code>
</summary>

```shell
@logs *ARGS:
    docker compose logs {{ ARGS }}
```
</details>

### manage

<details>
<summary>
<code>
$ just manage
</code>
</summary>

```shell
@manage *ARGS:
    docker compose run --rm --no-deps utility python -m manage {{ ARGS }}
```
</details>

### pg_dump

<details>
<summary>
<code>
$ just pg_dump
</code>
</summary>

```shell
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
```
</details>

### pg_restore

<details>
<summary>
<code>
$ just pg_restore
</code>
</summary>

```shell
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
```
</details>

### pre-commit

<details>
<summary>
<code>
$ just pre-commit
</code>
</summary>

```shell
@pre-commit *ARGS:
    python -m pre_commit run {{ ARGS }} --all-files
```
</details>

### restart

<details>
<summary>
<code>
$ just restart
</code>
</summary>

```shell
@restart *ARGS:
    docker compose restart {{ ARGS }}
```
</details>

### run

<details>
<summary>
<code>
$ just run
</code>
</summary>

```shell
@run *ARGS:
    docker compose run --rm --no-deps utility {{ ARGS }}
```
</details>

### start

<details>
<summary>
<code>
$ just start
</code>
</summary>

```shell
@start *ARGS="--detach":
    just up {{ ARGS }}
```
</details>

### stop

<details>
<summary>
<code>
$ just stop
</code>
</summary>

```shell
@stop:
    just down
```
</details>

### tail

<details>
<summary>
<code>
$ just tail
</code>
</summary>

```shell
@tail:
    just logs --follow
```
</details>

### test

<details>
<summary>
<code>
$ just test
</code>
</summary>

```shell
@test *ARGS:
    docker compose run --rm --no-deps utility python -m pytest {{ ARGS }}
```
</details>

### up

<details>
<summary>
<code>
$ just up
</code>
</summary>

```shell
@up *ARGS:
    docker compose up {{ ARGS }}
```
</details>

### upgrade

<details>
<summary>
<code>
$ just upgrade
</code>
</summary>

```shell
@upgrade:
    python -m pip install --upgrade pip uv
    python -m uv pip install --upgrade pre-commit
    python -m uv pip install --upgrade --requirement requirements.in
    just upgrade
```
</details>

<!-- [[[end]]] -->

## Author

👤 **Jeff Triplett**

* Website: https://jefftriplett.com
* Mastodon: [@webology@mastodon.social](https://mastodon.social/@webology)
* Xwitter: [@webology](https://twitter.com/webology)
* GitHub: [@jefftriplett](https://github.com/jefftriplett)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/jefftriplett/django-startproject/issues).

## Show your support

Give a ⭐️ if this project helped you!
