CREATE TABLE model_version_country (
  model_version INTEGER NOT NULL REFERENCES model_version(id),
  country TEXT NOT NULL REFERENCES country(id),
  primary key (model_version, country)
);
