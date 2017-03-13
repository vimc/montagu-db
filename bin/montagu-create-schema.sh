#!/usr/bin/env bash
set -e
montagu-wait.sh
sed "s/'current_timestamp'/CURRENT_TIMESTAMP/" /montagu-schema/montagu-db.sql | \
    psql -U $POSTGRES_USER -d $POSTGRES_DB
