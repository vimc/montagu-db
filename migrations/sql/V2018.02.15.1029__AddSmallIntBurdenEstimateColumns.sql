ALTER TABLE burden_estimate
  ADD COLUMN year_small SMALLINT,
  ADD COLUMN burden_outcome_small SMALLINT;

-- this will take around 2 hours
UPDATE burden_estimate
SET
  year_small           = year,
  burden_outcome_small = burden_outcome;