DROP TABLE burden_estimate_stochastic;

CREATE TABLE burden_estimate_stochastic (
  id                  BIGSERIAL NOT NULL,
  burden_estimate_set INTEGER   NOT NULL,
  model_run           INTEGER   NOT NULL,
  country             SMALLINT  NOT NULL,
  year                SMALLINT  NOT NULL,
  burden_outcome      SMALLINT  NOT NULL,
  value               NUMERIC,
  age                 SMALLINT,
  PRIMARY KEY ("id")
);

CREATE INDEX ON burden_estimate_stochastic (burden_estimate_set);

ALTER TABLE burden_estimate_stochastic
  ADD CONSTRAINT burden_estimate_stochastic_unique UNIQUE (
  burden_estimate_set,
  model_run,
  country,
  year,
  age,
  burden_outcome)
  DEFERRABLE INITIALLY DEFERRED;