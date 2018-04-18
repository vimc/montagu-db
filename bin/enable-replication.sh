#!/usr/bin/env bash
set -e

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
