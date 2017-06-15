#!/usr/bin/env bash

set -x

if [ "$#" -lt 1 ]; then
    echo "Expected at least one argument (the db hash)"
    exit 1
fi
if [ "$#" -gt 2 ]; then
    echo "Expected at most two arguments (the db hash)"
    exit 1
fi

MONTAGU_DB_TAG=$1
if [ "$#" -eq 2 ]; then
    MONTAGU_IMPORT_PATH=$2
    SCRIPT=import.R
    DUMP_ARGS=-Fc
    DUMP_NAME=montagu.dump
else
    MONTAGU_IMPORT_PATH=import
    SCRIPT=minimal.R
    DUMP_ARGS=
    DUMP_NAME=minimal.dump
fi


if [ ! -d $MONTAGU_IMPORT_PATH ]; then
    echo "Import path must exist and be a directory"
    exit 1
fi
MONTAGU_IMPORT_PATH_ABS=$(readlink -f $MONTAGU_IMPORT_PATH)

MONTAGU_IMPORT_PATH_CONTAINER=/montagu-import-data

MONTAGU_DB_HOST=montagu-db-server
MONTAGU_DB_IMAGE=docker.montagu.dide.ic.ac.uk:5000/montagu-db:${MONTAGU_DB_TAG}
MONTAGU_IMPORT_IMAGE=docker.montagu.dide.ic.ac.uk:5000/montagu-db-import:${MONTAGU_DB_TAG}

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
       ${MONTAGU_IMPORT_IMAGE} \
       Rscript $SCRIPT

SUCCESS=$?

if [ $SUCCESS -eq 0 ]; then
    echo "Success!"
    docker exec $MONTAGU_DB_HOST \
           pg_dump -U vimc $DUMP_ARGS montagu > $DUMP_NAME
else
    echo "Failure :("
fi

docker stop $MONTAGU_DB_HOST
docker network rm $MONTAGU_DB_NETWORK

exit $SUCCESS
