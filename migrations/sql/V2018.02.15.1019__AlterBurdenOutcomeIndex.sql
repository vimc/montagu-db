-- this took 16 minutes on UAT
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
