#!/usr/bin/env bash
set -ex

GIT_ID=$(git rev-parse --short HEAD)
GIT_BRANCH=$(git symbolic-ref --short HEAD)
REGISTRY=docker.montagu.dide.ic.ac.uk:5000
NAME=montagu-migrate

TAG=$REGISTRY/$NAME
COMMIT_TAG=$REGISTRY/$NAME:$GIT_ID
BRANCH_TAG=$REGISTRY/$NAME:$GIT_BRANCH
DB=$REGISTRY/montagu-db:$GIT_ID

docker build \
       --tag $COMMIT_TAG \
       --tag $BRANCH_TAG \
       -f migrations/Dockerfile \
       .

docker network create migration_test

function cleanup {
    docker stop db db-annex
    docker network rm migration_test
}
trap cleanup EXIT

# First the core database:
docker run --rm --network=migration_test -d --name db $DB
docker run --rm --network=migration_test -d --name db-annex $DB

# The main database *must* be migrated first because it will establish
# a subscription that the annex will listen to
docker run --rm --network=migration_test $COMMIT_TAG

# At this point the annex can be migrated safely
docker run --rm --network=migration_test $COMMIT_TAG -configFile=conf/flyway-annex.conf migrate

docker push $COMMIT_TAG
docker push $BRANCH_TAG
