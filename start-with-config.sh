#!/usr/bin/env bash
set -ex
cat $1 >> /pgdata/postgresql.conf
exec /docker-entrypoint.sh postgres