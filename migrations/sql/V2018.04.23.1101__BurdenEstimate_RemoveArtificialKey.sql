ALTER TABLE burden_estimate
  DROP COLUMN id,
  DROP CONSTRAINT burden_estimate_unique,
  ADD PRIMARY KEY (burden_estimate_set,
                      country,
                      year,
                      age,
                      burden_outcome);

ALTER FOREIGN TABLE burden_estimate_stochastic
  DROP COLUMN id;
