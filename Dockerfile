# ------------------------------------------------------------
# Tini layer - to save us from having to maintain our own
# ------------------------------------------------------------

FROM krallin/ubuntu-tini:trusty as tini

# ------------------------------------------------------------
# Base layer
# ------------------------------------------------------------

FROM python:3.7-slim-stretch as base

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN set -ex \
    && pip install --upgrade pip \
    && rm -rf /root/.cache/

WORKDIR /code

COPY --from=tini /usr/local/bin/tini /usr/local/bin/tini

ENTRYPOINT ["/usr/local/bin/tini", "--"]

# ------------------------------------------------------------
# Dependency layer
# ------------------------------------------------------------

FROM base AS dependencies

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY requirements.txt /code/

RUN set -ex \
    && pip install -r requirements.txt \
    && rm -rf /root/.cache/

# ------------------------------------------------------------
# Release / Production layer
# ------------------------------------------------------------

FROM dependencies AS release

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY . /code/

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
