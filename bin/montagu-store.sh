#!/usr/bin/env bash
set -e
/montagu-bin/wait-for-postgres.sh
psql -U $POSTGRES_USER -d postgres -c "DROP DATABASE IF EXISTS $POSTGRES_DB"
psql -U $POSTGRES_USER -d postgres -c "CREATE DATABASE $POSTGRES_DB"
pg_restore -U $POSTGRES_USER -d $POSTGRES_DB $1
