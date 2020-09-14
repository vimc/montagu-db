#!/usr/bin/env bash
## Starts container:
##
##   db - main db
##
## On the provided network, defaulting to
##
##   db_nw
set -e

if (( "$#" < 1 || "$#" > 3 )); then
    echo "Usage: start.sh <DB_VERSION> [<DB_PORT>] [<DB_NETWORK>]"
    echo "Starts the database using the specified image"
    echo "version. If DB_PORT is provided, exposes the main database on the "
    echo "host machine at that port."
    exit 1
fi

set -ex
DB_VERSION=$1
DB_PORT=$2
DB_NETWORK=$3

PORT_MAPPING=
if [[ ! -z $DB_PORT ]]; then
    PORT_MAPPING="-p $DB_PORT:5432"
fi

if [[ ! -z $PG_TEST_MODE ]]; then
    PG_CONFIG=/etc/montagu/postgresql.test.conf
fi

NETWORK=db_nw
if [[ ! -z $DB_NETWORK ]]; then
    NETWORK=$DB_NETWORK
fi

ORG=vimc

DB_IMAGE=$ORG/montagu-db:$DB_VERSION
MIGRATE_IMAGE=$ORG/montagu-migrate:$DB_VERSION

DB_CONTAINER=db
DB_PORT=5432    # Exposed on host machine

function cleanup {
    set +e
    docker stop $DB_CONTAINER
    docker network rm $NETWORK
}
trap cleanup EXIT

docker network create $NETWORK || true

docker pull $DB_IMAGE
docker pull $MIGRATE_IMAGE

# First the core database:
docker run --rm --network=$NETWORK -d \
    --name $DB_CONTAINER $PORT_MAPPING $DB_IMAGE $PG_CONFIG

# Wait for things to become responsive
docker exec $DB_CONTAINER montagu-wait.sh

# Do the migrations
docker run --rm --network=$NETWORK $MIGRATE_IMAGE

trap - EXIT
