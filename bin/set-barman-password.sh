#!/usr/bin/env bash
set -e
NEWPASSWORD=$1
psql -U $POSTGRES_USER -d $POSTGRES_DB -c \
    "ALTER USER barman WITH ENCRYPTED PASSWORD '$NEWPASSWORD'"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c \
     "ALTER USER streaming_barman WITH ENCRYPTED PASSWORD '$NEWPASSWORD'"
