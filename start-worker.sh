#!/bin/sh
# Starts the "worker" entry in PRODUCTION_PROCESSES (django-prodserver), which
# runs the Django-Q2 cluster in this process via qcluster. `exec` makes it
# PID 1's replacement so the container's stop signal reaches the cluster and
# it shuts down cleanly, instead of being killed after the stop timeout.
exec uv run --no-sync -m manage worker worker
