-- drop foreign keys from burden estimate and impact ingredient tables
ALTER TABLE burden_estimate
  DROP CONSTRAINT burden_estimate_burden_outcome_fkey;

ALTER TABLE impact_estimate_ingredient
  DROP CONSTRAINT impact_estimate_ingredient_burden_outcome_fkey;

-- drop primary key and alter type of burden_outcome.id
ALTER TABLE burden_outcome
  DROP CONSTRAINT burden_outcome_pkey,
  ALTER COLUMN id TYPE SMALLINT;

-- alter types on impact estimate ingredient and burden estimate tables
ALTER TABLE impact_estimate_ingredient
  ALTER COLUMN burden_outcome TYPE SMALLINT;

ALTER TABLE burden_estimate
  ALTER COLUMN burden_outcome TYPE SMALLINT;

-- add primary key constraint back
ALTER TABLE burden_outcome
  ADD CONSTRAINT burden_outcome_pkey
PRIMARY KEY (id);

-- add foreign key constraints back
-- takes 4 mins
ALTER TABLE impact_estimate_ingredient
  ADD CONSTRAINT impact_estimate_ingredient_burden_outcome_fkey
FOREIGN KEY (burden_outcome) REFERENCES burden_outcome (id);

ALTER TABLE burden_estimate
  ADD CONSTRAINT burden_estimate_burden_outcome_fkey
FOREIGN KEY (burden_outcome) REFERENCES burden_outcome (id);