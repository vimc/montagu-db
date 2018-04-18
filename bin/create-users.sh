#!/usr/bin/env bash
set -ex

# This is needed while we restore from the dump.  It can be removed
# once we move to the barman system fully.  This duplicates the logic
# from montagu's prepare_db_for_import() (database.py).

# It is also run during database initialisation (creation of the image
# /pgdata).

# Once the script is removed from the montagu-bin directory, the
# dropdb/createdb lines can be omitted
dropdb -U vimc --if-exists montagu
createdb -U vimc montagu

# Ordinary users

# TODO: permissions grants need to be handled somehow.  We do these
# after database import ordinarily.  They're probably worth adding as
# a schema migration though.  The users need to exist here though in
# order to perform the annex schema migration.  When we add new users,
# I don't think they go here.
createuser -U vimc api
createuser -U vimc import
createuser -U vimc orderly
createuser -U vimc readonly

# For backups
createuser -U vimc -w --superuser barman
createuser -U vimc -w --replication streaming_barman
