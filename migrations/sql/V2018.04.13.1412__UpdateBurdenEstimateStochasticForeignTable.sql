DROP FOREIGN TABLE burden_estimate_stochastic;

CREATE FOREIGN TABLE burden_estimate_stochastic (
  id                  BIGSERIAL NOT NULL,
  burden_estimate_set INTEGER   NOT NULL,
  model_run           INTEGER   NOT NULL,
  country             SMALLINT  NOT NULL,
  year                SMALLINT  NOT NULL,
  burden_outcome      SMALLINT  NOT NULL,
  value               REAL,
  age                 SMALLINT
)
SERVER montagu_db_annex
OPTIONS ( SCHEMA_NAME 'public', TABLE_NAME 'burden_estimate_stochastic');