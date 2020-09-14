#!/usr/bin/env bash

DB_NETWORK=$1
NETWORK=db_nw
if [[ ! -z $DB_NETWORK ]]; then
    NETWORK=$DB_NETWORK
fi

docker stop db || true
docker network rm $NETWORK || true
