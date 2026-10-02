#!/bin/sh
uv run --no-sync -m manage migrate --noinput

uv run --no-sync -m manage collectstatic --noinput

uv run --no-sync -m manage prodserver web
