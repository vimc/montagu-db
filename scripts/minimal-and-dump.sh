#!/usr/bin/env bash
set -x
MONTAGU_DB_HASH=$(git rev-parse --short HEAD)
REGISTRY=montagu.dide.ic.ac.uk:5000
docker pull $REGISTRY/montagu-db:$MONTAGU_DB_HASH
./import/scripts/import-and-dump.sh $MONTAGU_DB_HASH
