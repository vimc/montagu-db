#!/usr/bin/env bash
set -ex

DB_CONTAINER=db
DB_IMAGE=montagu_db
MIGRATE_IMAGE=montagu_migrate
NETWORK=db_nw

docker build --tag $DB_IMAGE .
docker build --tag $MIGRATE_IMAGE -f migrations/Dockerfile .

function cleanup {
    set +e
    docker stop $DB_CONTAINER
    docker network rm $NETWORK
}
trap cleanup EXIT

docker network create $NETWORK

docker run --rm --network=$NETWORK -d --name $DB_CONTAINER $DB_IMAGE

# Wait for things to become responsive
docker exec $DB_CONTAINER montagu-wait.sh

# Do the migrations
docker run --rm --network=$NETWORK $MIGRATE_IMAGE
