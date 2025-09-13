# syntax = docker/dockerfile:experimental
# Uses Docker BuildKit for improved caching and build performance

# ------------------------------------------------------------
# Stage 1: Base/builder layer - Setup Python environment
# ------------------------------------------------------------
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder

# Configure environment variables
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_SYSTEM_PYTHON 1

# Set working directory
WORKDIR /src/

# Install curl for health checks
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies using uv
# Mount only the necessary files (dependency definitions)
# This optimizes layer caching - changes to other files won't invalidate this layer
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync \
        --all-extras \
        --frozen \
        --no-install-project

# ------------------------------------------------------------
# Stage 2: Release - Final production image
# ------------------------------------------------------------
FROM builder AS release

# Use SIGINT for stopping the container
# This allows for graceful shutdown and proper cleanup
STOPSIGNAL SIGINT

ADD . /src/

# Copy the uv cache from builder stage to avoid re-downloading packages
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen

# Download the TailwindCSS CLI
# Using SQLite memory database and dummy secret key during build
# RUN DATABASE_URL=sqlite://:memory: SECRET_KEY=build-key uv run --frozen -m manage tailwind --skip-checks download_cli

# Build the TailwindCSS styles
# RUN DATABASE_URL=sqlite://:memory: SECRET_KEY=build-key uv run --frozen -m manage tailwind --skip-checks build

# Collect static files for production serving
RUN DATABASE_URL=sqlite://:memory: SECRET_KEY=build-key uv run --frozen -m manage collectstatic --noinput --clear

# Default command runs Gunicorn WSGI server
# - Binds to all interfaces on port 8000
# - Uses 2 worker processes for handling requests
CMD ["uv", "run", "--frozen", "-m", "manage", "prodserver", "web"]
