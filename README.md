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
