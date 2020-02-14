#!/usr/bin/env bash
set -ex

GIT_ID=$(git rev-parse --short=7 HEAD)
GIT_BRANCH=$(git symbolic-ref --short HEAD)
REGISTRY=docker.montagu.dide.ic.ac.uk:5000
NAME=montagu-migrate

TAG=$REGISTRY/$NAME
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

if [ "$GIT_BRANCH" == "master" ]; then
    PUBLIC_REGISTRY=vimc
    PUBLIC_TAG=$PUBLIC_REGISTRY/$NAME
    PUBLIC_COMMIT_TAG=$PUBLIC_TAG:$GIT_ID
    PUBLIC_BRANCH_TAG=$PUBLIC_TAG:$GIT_BRANCH
    docker tag $BRANCH_TAG $PUBLIC_BRANCH_TAG
    docker tag $BRANCH_TAG $PUBLIC_COMMIT_TAG
    docker push $PUBLIC_BRANCH_TAG
    docker push $PUBLIC_COMMIT_TAG
fi

export PG_TEST_MODE=1
$DIR/start.sh $GIT_ID
$DIR/stop.sh
