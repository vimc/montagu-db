#!/usr/bin/env bash
set -e
montagu-wait.sh
sed "s/'current_timestamp'/CURRENT_TIMESTAMP/" /montagu-schema/montagu-db.sql | \
    psql -v ON_ERROR_STOP=1 -U $POSTGRES_USER -d $POSTGRES_DB
