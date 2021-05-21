#!/usr/bin/env bash
set -ex
docker build --tag montagu-db .
docker run --rm -d -p 5432:5432 --name montagu-db montagu-db

docker build --tag montagu-migrate --file migrations/Dockerfile .
docker run --network=host montagu-migrate migrate -url=jdbc:postgresql://localhost/montagu

watch docker logs montagu-db
