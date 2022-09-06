# ------------------------------------------------------------
# Base/builder layer
# ------------------------------------------------------------

FROM python:3.10-slim-buster AS builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY requirements/requirements.txt /tmp/requirements.txt

# RUN --mount=type=cache,target=/root/.cache \
RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/

# ------------------------------------------------------------
# Dev/testing layer
# ------------------------------------------------------------

FROM builder AS release

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY . /src/

WORKDIR /src/

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# ------------------------------------------------------------
# TODO: Add Production notes
# ------------------------------------------------------------
