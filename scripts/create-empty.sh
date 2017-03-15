#!/usr/bin/env bash
set -e

IMAGE=vimc/montagu-db
DATA_VOLUME=$1

if [[ ! -z "${DATA_VOLUME}" && "$(docker volume ls -q -f name=${DATA_VOLUME})" != "" ]]; then
    echo "Data volume '$DATA_VOLUME' exists already"
    exit 1
fi

if [[ -z "${DATA_VOLUME}" ]]; then
    echo "Creating new unnamed data volume"
    DOCKER_VOLUME=$(docker volume create)
    echo "Volume name: ${DOCKER_VOLUME}"
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

BUILD_ID=$(docker run -d -v $DATA_VOLUME:/var/lib/postgresql/data $IMAGE)
docker exec -it $BUILD_ID montagu-create-schema.sh
docker stop $BUILD_ID
docker rm $BUILD_ID

echo "Created new data volume '$DATA_VOLUME'"
