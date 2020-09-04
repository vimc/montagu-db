BEGIN;

ALTER TABLE dettl_import_log
RENAME COLUMN date to start_time;

ALTER TABLE dettl_import_log
ADD COLUMN end_time TIMESTAMP WITH TIME ZONE,
ADD COLUMN duration REAL;

COMMIT;
