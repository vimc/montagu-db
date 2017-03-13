#!/usr/bin/env bash
set -e
# This is just an idea; we're going to need to be able to set the
# password for these if we're going to rely at all on password
# authentication.

# Need to ensure that this is non empty first

NEWPASSWORD=$1
psql -U $POSTGRES_USER -d $POSTGRES_DB -c \
    "ALTER USER $POSTGRES_USER WITH ENCRYPTED PASSWORD '$NEWPASSWORD'"
