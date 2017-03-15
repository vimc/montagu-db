#!/usr/bin/env bash

# To debug:
# set -x

DATA_VOLUME=$1

NETWORK=synthetic-build-nw
MONTAGU_DB=montagu-db-synthetic-build
IMAGE_BUILD=vimc/montagu-synthetic
IMAGE_POSTGRES=vimc/montagu-db

# Check that the data volume will not clobber an existing one
if [[ ! -z "${DATA_VOLUME}" && "$(docker volume ls -q -f name=${DATA_VOLUME})" != "" ]]; then
    echo "Data volume '$DATA_VOLUME' exists already"
    exit 1
fi

# Check that we have the required postgres image
if [[ "$(docker images -q ${IMAGE_POSTGRES} 2> /dev/null)" == "" ]]; then
    echo "Image '${IMAGE_POSTGRES}' does not exist; please build with scripts/create-montagu-db.sh"
    exit 1
fi

# Check that we have the required postgres image
if [[ "$(docker images -q ${IMAGE_BUILD} 2> /dev/null)" == "" ]]; then
    echo "Image '${IMAGE_BUILD}' does not exist; please build with scripts/create-montagu-db.sh"
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

docker network create $NETWORK
BUILD_ID=$(docker run -d \
                  -v ${DATA_VOLUME}:/var/lib/postgresql/data \
                  -v ${PWD}/schema:/montagu-schema \
                  --name $MONTAGU_DB \
                  --network $NETWORK \
                  $IMAGE_POSTGRES)
docker exec -it $BUILD_ID montagu-create-schema.sh
SUCCESS=$?

if [[ $SUCCESS -eq 0 ]]; then
    docker run --rm \
           --network $NETWORK \
           -e "MONTAGU_DB=${MONTAGU_DB}" \
           -v ${PWD}/synthetic:/build \
           -w /build \
           $IMAGE_BUILD \
           Rscript -e 'source("synthetic.R"); montagu_synthetic()'
    SUCCESS=$?
fi

docker stop $MONTAGU_DB
docker rm $MONTAGU_DB
docker network rm $NETWORK

if [[ $SUCCESS -eq 0 ]]; then
    echo "Created new data volume '$DATA_VOLUME'"
    exit 0
else
    echo "Build failed"
    exit 1
fi
