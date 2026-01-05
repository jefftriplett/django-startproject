#!/bin/sh
uv run -m manage migrate --noinput

uv run -m manage collectstatic --noinput

uv run -m manage prodserver web
