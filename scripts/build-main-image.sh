#!/usr/bin/env bash
set -e
HERE=$(dirname $0)
. $HERE/common

NAME=montagu-db

TAG=$ORG/$NAME
COMMIT_TAG=$TAG:$GIT_ID
BRANCH_TAG=$TAG:$GIT_BRANCH

docker build \
       --tag $COMMIT_TAG \
       --tag $BRANCH_TAG \
       .
docker push $COMMIT_TAG
docker push $BRANCH_TAG
