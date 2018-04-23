ALTER TABLE burden_estimate_stochastic
  DROP COLUMN id,
  DROP CONSTRAINT burden_estimate_stochastic_unique,
  ADD PRIMARY KEY (burden_estimate_set,
                   model_run,
                   country,
                   year,
                   age,
                   burden_outcome);