# ------------------------------------------------------------
# Tini layer - to save us from having to maintain our own
# ------------------------------------------------------------

FROM krallin/ubuntu-tini:trusty AS tini

# ------------------------------------------------------------
# Base/builder layer
# ------------------------------------------------------------

FROM python:3.7-slim-stretch AS builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY requirements/requirements.txt /tmp/requirements.txt

RUN set -ex \
    && pip install --upgrade pip \
    && pip install -r /tmp/requirements.txt \
    && rm -rf /root/.cache/

# ------------------------------------------------------------
# Dev/testing layer
# ------------------------------------------------------------

FROM builder AS testing

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY . /src/

WORKDIR /src/

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# ------------------------------------------------------------
# TODO: Add Production notes
# ------------------------------------------------------------
