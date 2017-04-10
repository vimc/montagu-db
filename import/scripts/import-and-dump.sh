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
MONTAGU_DB_IMAGE=montagu.dide.ic.ac.uk:5000/montagu-db:${MONTAGU_DB_TAG}

MONTAGU_DB_NETWORK=montagu-db-import-nw

NETWORK=$(docker network create $MONTAGU_DB_NETWORK)
docker run -d --rm \
       --name $MONTAGU_DB_HOST \
       --network $MONTAGU_DB_NETWORK \
       $MONTAGU_DB_IMAGE

# First wait for the container to come up; for now this should be enough
sleep 1

docker ps

docker run --rm \
       --network $MONTAGU_DB_NETWORK \
       -e MONTAGU_DB_HOST=$MONTAGU_DB_HOST \
       -e MONTAGU_DB_PORT=5432 \
       -e MONTAGU_IMPORT_PATH=$MONTAGU_IMPORT_PATH_CONTAINER \
       -v $MONTAGU_IMPORT_PATH_ABS:$MONTAGU_IMPORT_PATH_CONTAINER \
       montagu.dide.ic.ac.uk:5000/montagu-db-import:master \
       Rscript import.R

SUCCESS=$?

if [ $SUCCESS -eq 0 ]; then
    echo "Success!"
    docker exec $MONTAGU_DB_HOST \
           pg_dump -U vimc -Fc montagu > montagu.dump
else
    echo "Failure :("
fi

docker stop $MONTAGU_DB_HOST
docker network rm $MONTAGU_DB_NETWORK

exit $SUCCESS
