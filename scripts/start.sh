#!/usr/bin/env bash
## Starts a set of containers:
##
##   db - main db
##   db_annex - annex
##
## On the network
##
##   db_nw
set -e

if (( "$#" < 1 || "$#" > 3 )); then
    echo "Usage: start.sh <DB_VERSION> [<DB_PORT>] [<ANNEX_PORT>]"
    echo "Starts the database and the annex database, using the specified image"
    echo "version. If DB_PORT is provided, exposes the main database on the "
    echo "host machine at that port. If ANNEX_PORT is provided, additionally"
    echo "expose the annex database on the host machine at that port."
    exit 1
fi

set -ex
DB_VERSION=$1
DB_PORT=$2
ANNEX_PORT=$3

PORT_MAPPING=
if [[ ! -z $DB_PORT ]]; then
    PORT_MAPPING="-p $DB_PORT:5432"
fi

ANNEX_PORT_MAPPING=
if [[ ! -z $ANNEX_PORT ]]; then
    ANNEX_PORT_MAPPING="-p $ANNEX_PORT:5432"
fi

REGISTRY=docker.montagu.dide.ic.ac.uk:5000

DB_IMAGE=$REGISTRY/montagu-db:$DB_VERSION
MIGRATE_IMAGE=$REGISTRY/montagu-migrate:$DB_VERSION

DB_CONTAINER=db
DB_ANNEX_CONTAINER=db_annex
DB_PORT=5432    # Exposed on host machine
NETWORK=db_nw

function cleanup {
    set +e
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
docker run --rm --network=$NETWORK -d \
    --name $DB_CONTAINER $PORT_MAPPING $DB_IMAGE
docker run --rm --network=$NETWORK -d \
    --name $DB_ANNEX_CONTAINER $ANNEX_PORT_MAPPING $DB_IMAGE

# Wait for things to become responsive
docker exec $DB_CONTAINER montagu-wait.sh
docker exec $DB_ANNEX_CONTAINER montagu-wait.sh

# Do the migrations
docker run --rm --network=$NETWORK $MIGRATE_IMAGE -configFile=conf/flyway-annex.conf migrate
docker run --rm --network=$NETWORK $MIGRATE_IMAGE

trap - EXIT
