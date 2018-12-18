--- What this Migration is about
--- comment on model.is_current
--- &
--- creating three new table
--- 1. model_version_meta
--- 2. model_version_vaccine
--- 3. model_version_country
ALTER table model_version
	DROP COLUMN note,
	DROP COLUMN fingerprint;

COMMENT ON COLUMN model.is_current IS
  'TRUE if the model is currently running for VIMC.';

CREATE TABLE model_version_meta (
  id SERIAL,
  model_version INTEGER NOT NULL,
  is_dynamic BOOLEAN NOT NULL, 
  language TEXT,
  computes_dalys BOOLEAN NOT NULL,
  gender INTEGER NOT NULL,
  burden_min_age INTEGER NOT NULL,
  burden_max_age INTEGER NOT NULL,
  cohort_min INTEGER NOT NULL,
  cohort_max INTEGER NOT NULL,
  year_min INTEGER NOT NULL,
  year_max INTEGER NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (model_version) REFERENCES model_version(id),
  FOREIGN KEY (gender) REFERENCES gender(id)
);
COMMENT ON TABLE model_version_meta IS
  'General model metadata, including whether models consider herd effect, how models are coded, whether models provide DALYs, model observation shape - age/cohort/year ranges.';

CREATE TABLE model_version_vaccine (
  id SERIAL,
  model_version INTEGER NOT NULL,
  vaccine TEXT NOT NULL, 
  activity_type TEXT NOT NULL, 
  PRIMARY KEY (id),
  FOREIGN KEY (model_version) REFERENCES model_version(id),
  FOREIGN KEY (vaccine) REFERENCES vaccine(id),
  FOREIGN KEY (activity_type) REFERENCES activity_type(id)
);
COMMENT ON TABLE model_version_vaccine IS
  'Specify which vaccine deliveries (in delivery order) are evaluated in each model.';

CREATE TABLE model_version_country (
  id SERIAL,
  model_version INTEGER NOT NULL,
  pine_country TEXT NOT NULL, 
  PRIMARY KEY (id),
  FOREIGN KEY (model_version) REFERENCES model_version(id),
  FOREIGN KEY (pine_country) REFERENCES country(id)
);
COMMENT ON TABLE model_version_country IS
  'Specify which pine countries are considered in small-scale model run.';

CREATE TABLE model_version_outcome (
  id SERIAL,
  model_version INTEGER NOT NULL,
  outcome TEXT NOT NULL, 
  PRIMARY KEY (id),
  FOREIGN KEY (model_version) REFERENCES model_version(id),
  FOREIGN KEY (outcome) REFERENCES burden_outcome(code)
);
COMMENT ON TABLE model_version_outcome IS
  'Specify which burden outcomes are returned from each model.';




