#!/usr/bin/env bash
set -e

# This script imports a database dump into a running container.
# Depending on the size of the dump it will take a little while to run
# (~7s in May 2017).

if [ "$#" -ne 2 ]; then
    echo "Expected two arguments (path and container id)"
    exit 1
fi

PATH_DEST=/demography.dump
PATH_DUMP=$1
CONTAINER_ID=$2

if [ ! -f $PATH_DUMP ]; then
    echo "path must exist"
    exit 1
fi

docker cp "$PATH_DUMP" "$CONTAINER_ID:$PATH_DEST"
docker exec "$CONTAINER_ID" pg_restore \
       -U vimc -d montagu --verbose -e --disable-triggers --data-only \
           $PATH_DEST
docker exec "$CONTAINER_ID" rm "$PATH_DEST"
