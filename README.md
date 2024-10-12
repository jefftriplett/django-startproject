<h1 align="center">Welcome to django-startproject 👋</h1>
<p>
  <a href="https://github.com/jefftriplett/django-startproject/actions" target="_blank">
    <img alt="CI" src="https://github.com/jefftriplett/django-startproject/workflows/CI/badge.svg" />
  </a>
</p>

> Django startproject template with batteries

## :triangular_flag_on_post: Core Features

- Django 5.1
- Python 3.13
- Docker Compose
- Postgres auto updates
- uv support

## :triangular_flag_on_post: Django Features

- django-click
- environs[django]
- psycopg[binary]
- whitenoise

## :shirt: Linting/auto-formatting

- djade
- django-upgrade
- djhtml
- pre-commit
- pyupgrade
- ruff

### :green_heart: CI

- django-test-plus
- model-bakery
- pytest
- pytest-cov
- pytest-django

### 🏠 [Homepage](https://github.com/jefftriplett/django-startproject)

## :wrench: Install

```shell
$ uv run --with=django django-admin startproject \
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

# Lint the project / run pre-commit by hand
$ just lint

# Re-build PIP requirements
$ just lock
```

## `just` Commands

```shell
$ just --list
```
<!-- [[[cog
import subprocess
import cog

list = subprocess.run(['just', '--list'], stdout=subprocess.PIPE)
cog.out(
    f"```\n{list.stdout.decode('utf-8')}```"
)
]]] -->
```
Available recipes:
    bootstrap *ARGS
    build *ARGS
    console
    down *ARGS
    lint *ARGS
    lock *ARGS
    logs *ARGS
    manage *ARGS
    pg_dump file='db.dump'    # dump database to file
    pg_restore file='db.dump' # restore database dump from file
    restart *ARGS
    run *ARGS
    start *ARGS="--detach"
    stop *ARGS
    tail
    test *ARGS
    up *ARGS
    upgrade
```
<!-- [[[end]]] -->

## Author

👤 **Jeff Triplett**

* Website: https://jefftriplett.com
* Micro Blog: https://micro.webology.dev
* Mastodon: [@webology@mastodon.social](https://mastodon.social/@webology)
* Xwitter: [@webology](https://twitter.com/webology)
* GitHub: [@jefftriplett](https://github.com/jefftriplett)
* Hire me: [revsys](https://www.revsys.com)

## 🌟 Community Projects

* [Django News Newsletter](https://django-news.com)
* [Django News Jobs](https://jobs.django-news.com)
* [Django Packages](https://djangopackages.org)
* [DjangoCon US](https://djangocon.us)
* [Awesome Django](https://awesomedjango.org)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/jefftriplett/django-startproject/issues).

## Show your support

Give a ⭐️ if this project helped you!
