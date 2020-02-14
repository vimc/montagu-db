#!/usr/bin/env bash
set -e

GIT_ID=$(git rev-parse --short=7 HEAD)
GIT_BRANCH=$(git symbolic-ref --short HEAD)
REGISTRY=docker.montagu.dide.ic.ac.uk:5000
NAME=montagu-db

TAG=$REGISTRY/$NAME
COMMIT_TAG=$TAG:$GIT_ID
BRANCH_TAG=$TAG:$GIT_BRANCH

docker build \
       --tag $COMMIT_TAG \
       --tag $BRANCH_TAG \
       .
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
