#!/usr/bin/env bash

# TODO: this does not do restore!  This creates a *brand new* database
# every time.
#
# Once we move to having actual data we'll need to be much more
# careful about this.  I don't know if we'll need to go as far as the
# full deploy script (because this is only going to be run in relative
# isolation).
#
# So for now; destroy this annex with the script ./destroy.sh and when
# we start with backups we'll get this done more nicely.

set -e

ANNEX_VOLUME_NAME=montagu_db_annex_volume
ANNEX_CONTAINER_NAME=montagu_db_annex
ANNEX_IMAGE_NAME=montagu-db
ANNEX_IMAGE_VERSION=i880
ANNEX_PORT=15432

MONTAGU_REGISTRY=docker.montagu.dide.ic.ac.uk:5000

ANNEX_IMAGE=${MONTAGU_REGISTRY}/${ANNEX_IMAGE_NAME}:${ANNEX_IMAGE_VERSION}

export VAULT_ADDR=https://support.montagu.dide.ic.ac.uk:8200
ANNEX_VIMC_PASSWORD=$(vault read -field=password /secret/annex/users/vimc)
ANNEX_READONLY_PASSWORD=$(vault read -field=password /secret/annex/users/readonly)

if docker inspect -f '{{.State.Running}}' $ANNEX_CONTAINER_NAME > /dev/null; then
    echo "montagu db annex already exists: stopping"
    docker stop $ANNEX_CONTAINER_NAME
fi

if docker volume inspect $ANNEX_VOLUME_NAME > /dev/null 2>&1; then
    echo "montagu db annex volume already exists"
    INITIAL_DEPLOY=0
else
    echo "Creating montagu db annex volume"
    INITIAL_DEPLOY=1
    docker volume create $ANNEX_VOLUME_NAME
fi

docker pull $ANNEX_IMAGE

## TODO: add '--restart=always' to daemonise the container
docker run -d --rm \
       --restart=always \
       -p $ANNEX_PORT:5432 \
       -v $ANNEX_VOLUME_NAME:/pgdata \
       --name $ANNEX_CONTAINER_NAME \
       $ANNEX_IMAGE

# Wait for the container to come up
docker exec $ANNEX_CONTAINER_NAME montagu-wait.sh

echo "Setting vimc password"
docker exec $ANNEX_CONTAINER_NAME psql -U vimc -d montagu -c \
       "ALTER USER vimc WITH PASSWORD '${ANNEX_VIMC_PASSWORD}';"
