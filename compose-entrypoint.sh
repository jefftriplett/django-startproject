#!/usr/bin/env bash
set -eo pipefail

uv run -m manage migrate --noinput --skip-checks

uv run -m manage collectstatic --noinput --skip-checks

exec "$@"
