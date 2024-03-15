# ------------------------------------------------------------
# Base/builder layer
# ------------------------------------------------------------

FROM python:3.12-slim-bookworm AS builder

ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONPATH /srv
ENV PYTHONUNBUFFERED 1

COPY requirements.txt /tmp/requirements.txt

# add ",sharing=locked" if release should block until builder is complete
RUN --mount=type=cache,target=/root/.cache,sharing=locked,id=pip \
    python -m pip install --upgrade pip uv

RUN --mount=type=cache,target=/root/.cache,sharing=locked,id=pip \
    python -m uv pip install --system --requirement /tmp/requirements.txt

# ------------------------------------------------------------
# Dev/testing layer
# ------------------------------------------------------------

FROM builder AS release

COPY . /src/

WORKDIR /src/

CMD ["python", "-m", "manage", "runserver", "0.0.0.0:8000"]

# ------------------------------------------------------------
# TODO: Add Production notes
# ------------------------------------------------------------
