#!/usr/bin/env bash
## set -e
DATA_VOLUME_DEFAULT="montagu-db-synthetic"
DATA_VOLUME=${1-$DATA_VOLUME_DEFAULT}
NETWORK=synthetic-build-nw
MONTAGU_DB=montagu-db-synthetic-build
IMAGE_BUILD=vimc/montagu-synthetic

if [[ "$(docker images -q ${IMAGE_BUILD} 2> /dev/null)" == "" ]]; then
    echo "Image '${IMAGE_BUILD}' does not exist; building"
    docker build --tag $IMAGE_BUILD synthetic
else
    echo "Image '${IMAGE_BUILD}' exists"
fi

docker network create $NETWORK

docker volume rm $DATA_VOLUME || true
./scripts/create-empty.sh $DATA_VOLUME

docker run -d \
       -v ${DATA_VOLUME}:/var/lib/postgresql/data \
       --name $MONTAGU_DB \
       --network $NETWORK \
       vimc/montagu-db

docker run --rm --network $NETWORK -e "MONTAGU_DB=${MONTAGU_DB}" \
       -v ${PWD}/synthetic:/build -w /build \
       $IMAGE_BUILD Rscript -e 'source("synthetic.R"); montagu_synthetic()'

docker stop $MONTAGU_DB
docker rm $MONTAGU_DB
docker network rm $NETWORK
