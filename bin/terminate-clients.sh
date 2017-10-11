#!/usr/bin/env bash

set -ex

psql -d postgres -U vimc <<EOF
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'montagu'
AND pid <> pg_backend_pid();
EOF
