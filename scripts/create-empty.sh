#!/usr/bin/env bash
set -e

IMAGE=vimc/montagu-db
DATA_VOLUME_DEFAULT="montagu-db-data"
DATA_VOLUME=${1-$DATA_VOLUME_DEFAULT}

if [[ "$(docker volume ls -q -f name=${DATA_VOLUME})" != "" ]]; then
    echo "Data volume '$DATA_VOLUME' exists already"
    exit 1
fi

echo "Creating new data volume '$DATA_VOLUME'"
docker volume create $DATA_VOLUME

## TODO: It's possible this should only be built if it does not exist,
## but then this does not run well in other directories.

if [[ "$(docker images -q ${IMAGE} 2> /dev/null)" == "" ]]; then
    echo "Image '${IMAGE}' does not exist; building"
    docker build --tag $IMAGE .
else
    echo "Image '${IMAGE}' exists"
fi

BUILD_ID=$(docker run -d -v $DATA_VOLUME:/var/lib/postgresql/data $IMAGE)
docker exec -it $BUILD_ID montagu-create-schema.sh
docker stop $BUILD_ID
docker rm $BUILD_ID

echo "Created new data volume '$DATA_VOLUME'"
