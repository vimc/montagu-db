#!/usr/bin/env bash
set -ex

MONTAGU_BASENAME=`basename ${PWD}`
MONTAGU_NETWORK="${MONTAGU_BASENAME}_default"

MONTAGU_DB="${MONTAGU_BASENAME}_db_1"
MONTAGU_DB_ANNEX="${MONTAGU_BASENAME}_db-annex_1"

GIT_ID=$(git rev-parse --short HEAD)
REGISTRY=docker.montagu.dide.ic.ac.uk:5000
MIGRATE_IMAGE=$REGISTRY/montagu-migrate:$GIT_ID

docker pull $MIGRATE_IMAGE
docker pull $REGISTRY/montagu-db:i880

function cleanup {
    set +e
    docker-compose stop
    docker-compose rm -f -v
    docker network rm $MONTAGU_NETWORK
    docker volume rm "${MONTAGU_BASENAME}_db_volume" "${MONTAGU_BASENAME}_db_annex_volume"
trap cleanup EXIT

MONTAGU_DB_VERSION=i880 docker-compose up -d

docker cp /montagu/db.dump $MONTAGU_DB:/tmp/import.dump
docker exec $MONTAGU_DB /montagu-bin/restore-dump.sh /tmp/import.dump

docker run --rm --network=$MONTAGU_NETWORK $MIGRATE_IMAGE -configFile=conf/flyway-annex.conf migrate
docker run --rm --network=$MONTAGU_NETWORK $MIGRATE_IMAGE

# Nothing here
docker exec $MONTAGU_DB psql -U vimc -d montagu -c 'SELECT * FROM burden_estimate_stochastic;'

# Import some data into the annex
docker run -it --rm --network $MONTAGU_NETWORK -v ${PWD}:/workdir -w /workdir \
       --entrypoint Rscript $REGISTRY/montagu-orderly:master import.R

# And there it is!
docker exec $MONTAGU_DB psql -U vimc -d montagu -c 'SELECT * FROM burden_estimate_stochastic;'
