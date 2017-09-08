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
docker build -f SchemaSpy.Dockerfile --tag schemaspy .

docker network create migration_test
docker run --rm --network=migration_test -d --name db $DB
docker run --rm --network=migration_test $COMMIT_TAG
docker run --rm --network=migration_test -v $PWD/docs:/output schemaspy \
    -host db \
    -db montagu \
    -u vimc \
    -p changeme \
    -s public \
    -o /output

docker stop db
docker network rm migration_test

docker push $COMMIT_TAG
docker push $BRANCH_TAG
