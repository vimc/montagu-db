#!/usr/bin/env bash

# This script is designed to run within the container via "docker
# exec" and exists to simplify issues with quoting of the POSTGRES_
# environment variables from the parent shell.  It is used by
# load-dump-into-container

set -ex
PATH_DUMP=$1
DB_DEFAULT=postgres
pg_restore --clean -C --verbose --no-owner \
    -d "$DB_DEFAULT" -U "$POSTGRES_USER" "$PATH_DUMP"
