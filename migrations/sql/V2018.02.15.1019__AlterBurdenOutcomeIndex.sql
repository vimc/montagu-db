-- this took 16 minutes
-- disable triggers
ALTER TABLE burden_estimate DISABLE TRIGGER ALL;
ALTER TABLE impact_estimate_ingredient DISABLE TRIGGER ALL;
ALTER TABLE burden_outcome DISABLE TRIGGER ALL;

-- alter type of burden_outcome.id
ALTER TABLE burden_outcome
  ALTER COLUMN id TYPE SMALLINT;

-- alter types on impact estimate ingredient and burden estimate tables
ALTER TABLE impact_estimate_ingredient
  ALTER COLUMN burden_outcome TYPE SMALLINT;

ALTER TABLE burden_estimate
  ALTER COLUMN burden_outcome TYPE SMALLINT;

-- reenable triggers
ALTER TABLE burden_estimate ENABLE TRIGGER ALL;
ALTER TABLE impact_estimate_ingredient ENABLE TRIGGER ALL;
ALTER TABLE burden_outcome ENABLE TRIGGER ALL;

-- this one loses - 41 minutes!
-- disable triggers
-- ALTER TABLE burden_estimate DISABLE TRIGGER ALL;
-- ALTER TABLE impact_estimate_ingredient DISABLE TRIGGER ALL;
-- ALTER TABLE burden_outcome DISABLE TRIGGER ALL;
--
-- -- create new small typed columns
-- ALTER TABLE impact_estimate_ingredient
-- ADD COLUMN burden_outcome_small SMALLINT;
--
-- ALTER TABLE burden_estimate
--   ADD COLUMN burden_outcome_small SMALLINT;
--
-- -- update new columns
--   UPDATE impact_estimate_ingredient
-- SET burden_outcome_small = burden_outcome;
--
--   UPDATE burden_estimate
-- SET burden_outcome_small = burden_outcome;
--
-- -- drop large columns
-- ALTER TABLE impact_estimate_ingredient
-- DROP COLUMN burden_outcome;
--
-- ALTER TABLE burden_estimate
--   DROP COLUMN burden_outcome;
--
-- -- rename small columns
-- ALTER TABLE burden_estimate
--   RENAME COLUMN burden_outcome_small to burden_outcome;
--
--   ALTER TABLE impact_estimate_ingredient
-- RENAME COLUMN burden_outcome_small to burden_outcome;
--
-- -- renable triggers
-- ALTER TABLE burden_estimate ENABLE TRIGGER ALL;
-- ALTER TABLE impact_estimate_ingredient ENABLE TRIGGER ALL;
-- ALTER TABLE burden_outcome ENABLE TRIGGER ALL;