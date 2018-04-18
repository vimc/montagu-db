#!/usr/bin/env bash
set -e

if [ "$#" -ne 2 ]; then
    echo "Expected two parameters"
    exit 1
fi
PASSWORD_BARMAN=$1
PASSWORD_STREAM=$2

psql -U $POSTGRES_USER -d $POSTGRES_DB -c \
    "ALTER ROLE barman WITH PASSWORD '$PASSWORD_BARMAN'"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c \
    "ALTER ROLE streaming_barman WITH PASSWORD '$PASSWORD_STREAM'"

# Replication slot too, ensuring that it is not recreated if this is rerun
psql -v ON_ERROR_STOP=1 -U vimc -d postgres <<EOF
DO \$\$
BEGIN
IF
  (SELECT count(*) = 0 FROM pg_replication_slots WHERE slot_name = 'barman')
  THEN
    PERFORM * from pg_create_physical_replication_slot('barman');
END IF;
END
\$\$;
SELECT * FROM pg_replication_slots WHERE slot_name = 'barman';
EOF
