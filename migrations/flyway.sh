#!/usr/bin/env bash
docker build --tag montagu-migrations .
docker run --rm --network=montagu_default montagu-migrations "$@"
