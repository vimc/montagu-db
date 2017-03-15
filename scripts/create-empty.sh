#!/usr/bin/env bash

# To debug:
# set -x

IMAGE=vimc/montagu-db
DATA_VOLUME=$1

if [[ ! -z "${DATA_VOLUME}" && "$(docker volume ls -q -f name=${DATA_VOLUME})" != "" ]]; then
    echo "Data volume '$DATA_VOLUME' exists already"
    exit 1
fi

if [[ -z "${DATA_VOLUME}" ]]; then
    echo "Creating new unnamed data volume"
    DATA_VOLUME=$(docker volume create)
    echo "Volume name: ${DATA_VOLUME}"
else
    echo "Creating new data volume '${DATA_VOLUME}'"
    docker volume create ${DATA_VOLUME}
fi

if [[ "$(docker images -q ${IMAGE} 2> /dev/null)" == "" ]]; then
    echo "Image '${IMAGE}' does not exist; building"
    docker build --no-cache --tag $IMAGE .
else
    echo "Image '${IMAGE}' exists"
fi

BUILD_ID=$(docker run -d \
                  -v ${DATA_VOLUME}:/var/lib/postgresql/data \
                  -v ${PWD}/schema:/montagu-schema \
                  $IMAGE)
docker exec -it $BUILD_ID montagu-create-schema.sh
SUCCESS=$?
docker stop $BUILD_ID
docker rm $BUILD_ID

if [[ $SUCCESS -eq 0 ]]; then
    echo "Created new data volume '$DATA_VOLUME'"
    exit 0
else
    echo "Build failed"
    exit 1
fi
