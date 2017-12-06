#!/usr/bin/env bash

set -ex

if [ "$#" -ne 1 ]; then
    echo "Usage: start.sh <DB_VERSION>"
    exit 1
fi

DB_VERSION=$1

## Starts a set of containers:
##
##   db - main db
##   db_annex - annex
##
## On the network
##
##   db_nw

REGISTRY=docker.montagu.dide.ic.ac.uk:5000

DB_IMAGE=$REGISTRY/montagu-db:$DB_VERSION
MIGRATE_IMAGE=$REGISTRY/montagu-migrate:$DB_VERSION

DB_CONTAINER=db
DB_ANNEX_CONTAINER=db_annex
NETWORK=db_nw

function cleanup {
    docker stop $DB_CONTAINER $DB_ANNEX_CONTAINER
    docker network rm $NETWORK
}
trap cleanup EXIT

docker network create $NETWORK

# Pull fresh images, but if it fails continue so as to facilitate
# situations with no registry access
docker pull $DB_IMAGE || true
docker pull $MIGRATE_IMAGE || true

# First the core database:
docker run --rm --network=$NETWORK -d --name $DB_CONTAINER $DB_IMAGE
docker run --rm --network=$NETWORK -d --name $DB_ANNEX_CONTAINER $DB_IMAGE

# Wait for things to become responsive
docker exec $DB_CONTAINER montagu-wait.sh
docker exec $DB_ANNEX_CONTAINER montagu-wait.sh

# Do the migrations
docker run --rm --network=$NETWORK $MIGRATE_IMAGE -configFile=conf/flyway-annex.conf migrate
docker run --rm --network=$NETWORK $MIGRATE_IMAGE

trap - EXIT
