#!/usr/bin/env bash

set -x

if [ "$#" -ne 2 ]; then
    echo "Expected one argument (the import path)"
    exit 1
fi
MONTAGU_IMPORT_PATH=$1
MONTAGU_DB_TAG=$2

if [ ! -d $MONTAGU_IMPORT_PATH ]; then
    echo "Import path must exist and be a directory"
    exit 1
fi
MONTAGU_IMPORT_PATH_ABS=$(readlink -f $MONTAGU_IMPORT_PATH)

MONTAGU_IMPORT_PATH_CONTAINER=/montagu-import-data

MONTAGU_DB_HOST=montagu-db-server
MONTAGU_DB_IMAGE=docker.montagu.dide.ic.ac.uk:5000/montagu-db:${MONTAGU_DB_TAG}
MONTAGU_IMPORT_IMAGE=docker.montagu.dide.ic.ac.uk:5000/montagu-db-import:${MONTAGU_DB_TAG}

docker run -d --rm \
       -p 8888:5432 \
       --name $MONTAGU_DB_HOST \
       $MONTAGU_DB_IMAGE

# First wait for the container to come up; for now this should be enough
sleep 1

docker ps

docker run --rm \
       --network host \
       -e MONTAGU_DB_HOST="localhost" \
       -e MONTAGU_DB_PORT=8888 \
       -e MONTAGU_IMPORT_PATH=$MONTAGU_IMPORT_PATH_CONTAINER \
       -v $MONTAGU_IMPORT_PATH_ABS:$MONTAGU_IMPORT_PATH_CONTAINER \
       ${MONTAGU_IMPORT_IMAGE} \
       Rscript import.R

SUCCESS=$?

if [ $SUCCESS -eq 0 ]; then
    echo "Success!"
    docker attach $MONTAGU_DB_HOST
else
    echo "Failure :("
    exit 1
fi
