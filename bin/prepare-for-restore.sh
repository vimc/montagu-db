#!/usr/bin/env bash

set -ex

# This is needed while we restore from the dump.  It can be removed
# once we move to the barman system fully.  This duplicates the logic
# from montagu's prepare_db_for_import() (database.py)
dropdb -U vimc --if-exists montagu
createdb -U vimc montagu
createuser -U vimc api
createuser -U vimc import
createuser -U vimc orderly
createuser -U vimc readonly
