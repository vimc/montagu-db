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
       .

docker network create migration_test
docker run --rm --network=migration_test -d --name db $DB
docker run --rm --network=migration_test $COMMIT_TAG baseline -baselineVersion=0
docker run --rm --network=migration_test $COMMIT_TAG migrate
docker stop db
docker network rm migration_test

docker push $COMMIT_TAG
docker push $BRANCH_TAG