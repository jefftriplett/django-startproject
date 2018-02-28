# ------------------------------------------------------------
# Tini layer - to save us from having to maintain our own
# ------------------------------------------------------------

FROM krallin/ubuntu-tini:trusty as tini

# ------------------------------------------------------------
# Base layer
# ------------------------------------------------------------

FROM python:3.6.4-slim-stretch as base

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN set -ex \
    && pip install pipenv \
    && rm -rf /root/.cache/

WORKDIR /code

COPY Pipfile Pipfile.lock /code/

COPY --from=tini /usr/local/bin/tini /usr/local/bin/tini

ENTRYPOINT ["/usr/local/bin/tini", "--"]

# ------------------------------------------------------------
# Dependency layer
# ------------------------------------------------------------

FROM base AS dependencies

RUN set -ex \
    && pipenv install --deploy \
    && rm -rf /root/.cache/

# ------------------------------------------------------------
# Testing layer
# ------------------------------------------------------------

FROM dependencies AS test

RUN set -ex \
    && pipenv install --deploy --dev \
    && rm -rf /root/.cache/

COPY . /code/

RUN pipenv run py.test

# ------------------------------------------------------------
# Release / Production layer
# ------------------------------------------------------------

FROM dependencies AS release

COPY . /code/

EXPOSE 8000

CMD ["pipenv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
