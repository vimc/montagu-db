CREATE TABLE burden_estimate_new (
  id                  INTEGER  NOT NULL,
  burden_estimate_set INTEGER  NOT NULL,
  country             SMALLINT NOT NULL,
  year                SMALLINT NOT NULL,
  burden_outcome      SMALLINT NOT NULL,
  value               NUMERIC,
  age                 SMALLINT,
  model_run           INTEGER
);

INSERT INTO burden_estimate_new
  (SELECT
      burden_estimate.id,
      burden_estimate.burden_estimate_set,
      burden_estimate.model_run,
      burden_estimate.burden_outcome,
      country.nid AS country,
      burden_estimate.year,
      burden_estimate.age,
      burden_estimate.value
    FROM burden_estimate
      JOIN country ON burden_estimate.country = country.id);

DROP TABLE burden_estimate;

ALTER TABLE burden_estimate_new
  RENAME TO burden_estimate;

ALTER TABLE burden_estimate
  ADD PRIMARY KEY (id);

ALTER TABLE burden_estimate
  ADD CONSTRAINT burden_estimate_country_nid
FOREIGN KEY (country) REFERENCES country (nid);

ALTER TABLE burden_estimate
  ADD CONSTRAINT burden_estimate_burden_estimate_set
FOREIGN KEY (burden_estimate_set) REFERENCES burden_estimate_set (id);

ALTER TABLE burden_estimate
  ADD CONSTRAINT burden_estimate_burden_outcome
FOREIGN KEY (burden_outcome) REFERENCES burden_outcome (id);

ALTER TABLE burden_estimate
  ADD CONSTRAINT burden_estimate_model_run
FOREIGN KEY (model_run) REFERENCES model_run (internal_id);

-- We are going to want to retrieve all burden estimates from a given set, so
-- let's make that faster
CREATE INDEX ON burden_estimate (burden_estimate_set);

ALTER TABLE burden_estimate
  ADD CONSTRAINT burden_estimate_unique UNIQUE (
  burden_estimate_set,
  country,
  year,
  age,
  burden_outcome
)