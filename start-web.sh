#!/bin/sh
uv run --no-sync -m manage migrate --noinput

# Starts the "web" entry in PRODUCTION_PROCESSES (django-prodserver). `exec`
# hands the container's stop signal to the server so it shuts down cleanly
# instead of being killed after the stop timeout.
exec uv run --no-sync -m manage server web
