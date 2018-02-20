DROP TABLE burden_estimate_stochastic;

CREATE TABLE burden_estimate_stochastic (
  id BIGSERIAL NOT NULL,
  burden_estimate_set integer NOT NULL,
  country text NOT NULL,
  country_nid SMALLINT NULL,
  year SMALLINT NOT NULL,
  burden_outcome SMALLINT NOT NULL,
  stochastic boolean NOT NULL,
  value numeric,
  age SMALLINT,
  PRIMARY KEY ("id")
);

CREATE INDEX ON burden_estimate_stochastic (burden_estimate_set);

ALTER TABLE burden_estimate_stochastic
  ADD CONSTRAINT burden_estimate_stochastic_unique UNIQUE (
  burden_estimate_set,
  country,
  year,
  age,
  burden_outcome) DEFERRABLE INITIALLY DEFERRED;