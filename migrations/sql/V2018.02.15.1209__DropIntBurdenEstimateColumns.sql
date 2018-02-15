ALTER TABLE burden_estimate
  DISABLE TRIGGER ALL;

ALTER TABLE burden_estimate
  DROP COLUMN year,
  DROP COLUMN burden_outcome;

ALTER TABLE burden_estimate
  RENAME COLUMN year_small to year,
  RENAME COLUMN burden_outcome_small to burden_outcome;

ALTER TABLE burden_estimate
  ENABLE TRIGGER ALL;
