ALTER TABLE burden_estimate
  DROP COLUMN id,
  ADD PRIMARY KEY (burden_estimate_set,
                   country,
                   year,
                   age,
                   burden_outcome),
  DROP CONSTRAINT burden_estimate_unique;
