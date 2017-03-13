#!/usr/bin/env bash
set -e
/montagu-bin/wait-for-postgres.sh
pg_dump -U $POSTGRES_USER -Fc $POSTGRES_DB > $1
