#!/usr/bin/env bash
set -ex

GIT_ID=$(git rev-parse --short=7 HEAD)
GIT_BRANCH=$(git symbolic-ref --short HEAD)
ORG=vimc
NAME=montagu-migrate

TAG=$ORG/$NAME
COMMIT_TAG=$TAG:$GIT_ID
BRANCH_TAG=$TAG:$GIT_BRANCH

## Get directory of the 'scripts/' directory
DIR=$(dirname "$(readlink -f "$0")")

docker build \
       --tag $COMMIT_TAG \
       --tag $BRANCH_TAG \
       -f migrations/Dockerfile \
       .

# run this first to avoid a spurious pull error message
docker push $COMMIT_TAG
docker push $BRANCH_TAG

export PG_TEST_MODE=1
$DIR/start.sh $GIT_ID
$DIR/stop.sh
