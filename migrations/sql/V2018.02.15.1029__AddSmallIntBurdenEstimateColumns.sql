ALTER TABLE burden_estimate
  DISABLE TRIGGER ALL;

ALTER TABLE burden_estimate
  ADD COLUMN year_small SMALLINT,
  ADD COLUMN burden_outcome_small SMALLINT;

UPDATE burden_estimate
SET
  year_small           = year,
  burden_outcome_small = burden_outcome;


ALTER TABLE burden_estimate
  ENABLE TRIGGER ALL;