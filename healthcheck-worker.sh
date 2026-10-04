#!/bin/sh
# Healthy only if a django-q cluster process is actually running in this container.
#
# `manage qinfo` can't tell: its stats live in the cache, which is per-process
# LocMemCache here, and its output says "Workers" even with no cluster at all.
# That let a container running the web server pass as a healthy worker for months.
#
# start-worker.sh runs the cluster through django-prodserver's `manage worker
# worker`, which calls qcluster in-process, so that is the command line to look
# for (the cluster's forked processes share it).
for cmdline in /proc/[0-9]*/cmdline; do
    if tr '\0' ' ' < "$cmdline" 2>/dev/null | grep -q "manage worker worke[r]"; then
        exit 0
    fi
done

echo "No django-q cluster (manage worker worker) is running in this container"
exit 1
