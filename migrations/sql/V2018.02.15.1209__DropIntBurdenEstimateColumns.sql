ALTER TABLE burden_estimate
  DISABLE TRIGGER ALL;

ALTER TABLE burden_estimate
  DROP COLUMN year,
  DROP COLUMN burden_outcome;

ALTER TABLE burden_estimate
  ENABLE TRIGGER ALL;
