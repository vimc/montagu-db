#!/bin/sh
set -ex

REAL_ANNEX_HOST=annex.montagu.dide.ic.ac.uk
REAL_ANNEX_PORT=15432

# Restore from backup
cd montagu-backup
./restore.py

# Read data from the local database (just restored) and the real annex
vault auth -method=github
set +x
export PGPASSWORD=$(vault read -field=value secret/annex/password)

set -x
test_query="SELECT * FROM burden_estimate_stochastic 
ORDER BY id DESC LIMIT 5000;"

psql -h localhost -p 15432 -U vimc -d montagu \
    -c "$test_query" > /vagrant/from_backup
psql -h $REAL_ANNEX_HOST -p $REAL_ANNEX_PORT -U vimc -d montagu \
    -c "$test_query" > /vagrant/from_live
