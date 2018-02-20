-- drop all constraints on the table
ALTER TABLE burden_estimate
  DROP CONSTRAINT burden_estimate_unique,
  DROP CONSTRAINT burden_estimate_burden_estimate_set_fkey,
  DROP CONSTRAINT burden_estimate_country_fkey,
  DROP CONSTRAINT burden_estimate_pkey,
  DROP CONSTRAINT burden_estimate_model_run_fkey,
  DROP CONSTRAINT burden_estimate_burden_outcome_fkey;

-- set data types to small ints
ALTER TABLE burden_estimate
  ALTER COLUMN year SET DATA TYPE SMALLINT,
  ALTER COLUMN burden_outcome SET DATA TYPE SMALLINT;

-- add constraints back
ALTER TABLE burden_estimate
  ADD CONSTRAINT burden_estimate_unique UNIQUE (
  burden_estimate_set,
  country,
  year,
  age,
  burden_outcome
),

  ADD CONSTRAINT burden_estimate_burden_estimate_set_fkey
FOREIGN KEY (burden_estimate_set) REFERENCES burden_estimate_set (id),

  ADD CONSTRAINT burden_estimate_country
FOREIGN KEY (country) REFERENCES country (id),

  ADD CONSTRAINT burden_estimate_pkey
PRIMARY KEY (id),

  ADD CONSTRAINT burden_estimate_model_run_fkey
FOREIGN KEY (model_run) REFERENCES model_run (internal_id),

  ADD CONSTRAINT burden_estimate_burden_outcome_fkey
FOREIGN KEY (burden_outcome) REFERENCES burden_outcome (id);
