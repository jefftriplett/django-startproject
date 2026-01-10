# ------------------------------------------------------------
# Stage 1: Base/builder layer - Setup Python environment
# ------------------------------------------------------------
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder

# Configure environment variables
ENV UV_SYSTEM_PYTHON=1
ENV UV_LINK_MODE=copy

# Set working directory
WORKDIR /src/

# Install curl for health checks and procps for pgrep
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    curl \
    procps \
    wget

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

COPY . /src/

# Copy the uv cache from builder stage and compile bytecode once
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --compile

# Download the TailwindCSS CLI
# Using SQLite memory database and dummy secret key during build
RUN DATABASE_URL=sqlite://:memory: SECRET_KEY=build-key uv run --frozen -m manage tailwind --skip-checks download_cli

# Build the TailwindCSS styles
RUN DATABASE_URL=sqlite://:memory: SECRET_KEY=build-key uv run --frozen -m manage tailwind --skip-checks build

# Collect static files for production serving
RUN DATABASE_URL=sqlite://:memory: SECRET_KEY=build-key uv run --frozen -m manage collectstatic --noinput

CMD ["/src/start-web.sh"]

# Worker stage
FROM release AS worker

HEALTHCHECK --interval=60s --timeout=30s --start-period=30s --retries=3 \
    CMD ["/src/healthcheck-worker.sh"]

CMD ["/src/start-worker.sh"]

# Web stage (default)
FROM release AS web

HEALTHCHECK --interval=60s --timeout=10s --start-period=40s --retries=3 \
    CMD ["/src/healthcheck-web.sh"]

CMD ["/src/start-web.sh"]
