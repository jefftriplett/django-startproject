#!/bin/sh
# Healthy only when /health/ answers 200. `curl -f` alone treats a redirect
# (an SSL or login redirect, 301/302) as success, which would pass without the
# database check ever running.
status=$(curl -s -o /dev/null -w '%{http_code}' --max-time 4 http://localhost:8000/health/)
[ "$status" = "200" ] && exit 0
echo "/health/ returned ${status:-no response}"
exit 1
