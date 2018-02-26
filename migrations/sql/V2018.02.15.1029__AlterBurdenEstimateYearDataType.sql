-- this took 1 hour 16 mins on UAT
-- change data type
ALTER TABLE burden_estimate DISABLE TRIGGER ALL;

-- set data types to small ints
ALTER TABLE burden_estimate
  ALTER COLUMN year SET DATA TYPE SMALLINT;

ALTER TABLE burden_estimate ENABLE TRIGGER ALL;
