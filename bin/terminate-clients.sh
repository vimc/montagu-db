#!/usr/bin/env bash

set -ex

# Terminate all clients connected to the montagu database except for
# the calling one:
#
# https://stackoverflow.com/a/5408501
psql -d postgres -U vimc <<EOF
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'montagu'
AND pid <> pg_backend_pid();
EOF
