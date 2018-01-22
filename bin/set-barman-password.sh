#!/usr/bin/env bash
set -e
PASSWORD=$1

createuser -U vimc -w --superuser   barman || true
createuser -U vimc -w --replication streaming_barman || true

psql -U $POSTGRES_USER -d $POSTGRES_DB -c \
    "ALTER ROLE barman WITH PASSWORD '$PASSWORD'"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c \
    "ALTER ROLE streaming_barman WITH PASSWORD '$PASSWORD'"
