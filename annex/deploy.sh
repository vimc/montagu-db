#!/usr/bin/env bash
set -e

ANNEX_VOLUME_NAME=montagu_db_annex_volume
ANNEX_CONTAINER_NAME=montagu_db_annex
ANNEX_IMAGE_NAME=montagu-db
ANNEX_IMAGE_VERSION=master
ANNEX_PORT=15432

ORG=vimc

ANNEX_IMAGE=${ORG}/${ANNEX_IMAGE_NAME}:${ANNEX_IMAGE_VERSION}

if docker volume inspect $ANNEX_VOLUME_NAME > /dev/null 2>&1; then
    echo "montagu db annex volume already exists"
    INITIAL_DEPLOY=0
else
    echo "Fetching annex password"
    export VAULT_ADDR=https://vault.dide.ic.ac.uk:8200
    vault login -method=github
    ANNEX_VIMC_PASSWORD=$(vault read -field=password /secret/vimc/annex/users/vimc)

    echo "Creating montagu db annex volume"
    INITIAL_DEPLOY=1
    docker volume create $ANNEX_VOLUME_NAME
fi


docker pull $ANNEX_IMAGE

if docker inspect -f '{{.State.Running}}' $ANNEX_CONTAINER_NAME > /dev/null 2>&1; then
    echo "montagu db annex already exists: stopping"
    docker stop $ANNEX_CONTAINER_NAME
    docker rm $ANNEX_CONTAINER_NAME
fi

docker run -d \
       --restart=always \
       --shm-size=512M \
       -p $ANNEX_PORT:5432 \
       -v $ANNEX_VOLUME_NAME:/pgdata \
       --name $ANNEX_CONTAINER_NAME \
       $ANNEX_IMAGE /etc/montagu/postgresql.production.conf

# Wait for the container to come up
docker exec $ANNEX_CONTAINER_NAME montagu-wait.sh

if [ $INITIAL_DEPLOY = 1 ]; then
    echo "Setting vimc password"
    docker exec $ANNEX_CONTAINER_NAME psql -U vimc -d montagu -c \
           "ALTER USER vimc WITH PASSWORD '${ANNEX_VIMC_PASSWORD}';"
fi
