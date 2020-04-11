<h1 align="center">Welcome to django-startproject 👋</h1>
<p>
  <a href="https://twitter.com/webology" target="_blank">
    <img alt="Twitter: webology" src="https://img.shields.io/twitter/follow/webology.svg?style=social" />
  </a>
  <a href="https://github.com/jefftriplett/django-startproject/actions" target="_blank">
    <img alt="CI" src="https://github.com/jefftriplett/django-startproject/workflows/CI/badge.svg" />
  </a>
</p>

> Bare bones Django startproject template

## Features

- Django 3.0.x
- django-click
- django-environ
- Docker
- Docker Compose
- pip-tools
- psycopg2-binary
- black
- pytest

### 🏠 [Homepage](https://github.com/jefftriplett/django-startproject)

## Install

```shell
$ django-admin startproject \
    --extension=ini,py,yml \
    --template=https://github.com/jefftriplett/django-startproject/archive/master.zip \
    example_project
```

## Usage

```shell
$ docker-compose build
$ docker-compose run --rm web python manage.py migrate
$ docker-compose run --rm web python manage.py createsuperuser
$ docker-compose up --rm
```

## Author

👤 **Jeff Triplett**

* Website: https://jefftriplett.com
* Twitter: [@webology](https://twitter.com/webology)
* Github: [@jefftriplett](https://github.com/jefftriplett)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/jefftriplett/django-startproject/issues). 

## Show your support

Give a ⭐️ if this project helped you!
