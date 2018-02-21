-- change data type
ALTER TABLE burden_estimate DISABLE TRIGGER ALL;

-- set data types to small ints
ALTER TABLE burden_estimate
  ALTER COLUMN year SET DATA TYPE SMALLINT;

ALTER TABLE burden_estimate ENABLE TRIGGER ALL;

-- change via new column
-- ALTER TABLE burden_estimate
--   ADD COLUMN year_small SMALLINT NULL;
--
-- UPDATE burden_estimate
-- SET year_small = year;
--
-- ALTER TABLE burden_estimate
--   DROP COLUMN year,
-- RENAME COLUMN year_small TO year;
--
-- ALTER TABLE burden_estimate ENABLE TRIGGER ALL;
