-- NOTE for review:
--
-- does it makes sense to prefix these tables with country_ or not?
-- check null ness for everything
-- everything that needs to be an enum table done
-- no "data" in column names (e.g., thing_2008, thing_yf, etc)
-- some of the not-null constraints need to be relaxed until we have the data import done - this needs writing out as a second import.


CREATE TABLE country_gavi_region (
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  primary KEY (id)
);
COMMENT ON TABLE country_gavi_region
  'include four types of gavi region interested by gavi doners';

CREATE TABLE country_disease_endemic (
  country TEXT  NOT NULL,
  disease TEXT  NOT NULL,
  FOREIGN KEY ("country") REFERENCES country (id),
  FOREIGN KEY ("disease") REFERENCES disease (id));

CREATE TABLE country_fragility (
  id SERIAL,
  country TEXT NOT NULL,
  year INTEGER NOT NULL,
  is_fragile BOOLEAN NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY ("country") REFERENCES country (id)
);

CREATE TABLE cofinance_status (
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  primary KEY (id)
);

CREATE TABLE country_cofinance (
  id SERIAL,
  country TEXT NOT NULL,
  year INTEGER NOT NULL,
  cofinance_status text NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY ("country") REFERENCES country (id)
  FOREIGN KEY ("cofinance_status") REFERENCES cofinance_status (id)
);

CREATE TABLE worldbank_status (
  id TEXT NOT NULL
  name TEXT NOT NULL
  PRIMARY KEY (id)
);
COMMENT ON TABLE worldbank_status
  'Country development status according to the worldbank';


CREATE TABLE country_worldbank_income_status (
  id  SERIAL,
  touchstone TEXT NOT NULL,
  country TEXT NOT NULL,
  year INTEGER NOT NULL,
  worldbank_status TEXT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (touchstone) REFERENCES touchstone(id),
  FOREIGN KEY (country) REFERENCES country(id),
  FOREIGN KEY (worldbank_status) REFERENCES worldbank_status(id),
  UNIQUE (touchstone, country, year)
);

ALTER TABLE country_metadata
  ADD COLUMN francophone TEXT NOT NULL,
  ADD COLUMN vxdel_segement TEXT NOT NULL,
  -- various country groupings
  ADD COLUMN pine_5 BOOLEAN NOT NULL,
  ADD COLUMN dove94 BOOLEAN NOT NULL,
  ADD COLUMN gavi68 BOOLEAN NOT NULL,
  ADD COLUMN gavi72 BOOLEAN NOT NULL,
  ADD COLUMN gavi77 BOOLEAN NOT NULL,
  ADD COLUMN dove96 BOOLEAN NOT NULL,

  ADD COLUMN gavi_region TEXT,
  ADD COLUMN gavi_pef_type TEXT,

COMMENT ON COLUMN country_metadata.francophone IS
  '28 Gavi-supported French-speaking countries of interest to Gavi donors + 1 associated member + 4 observer counrties';

COMMENT ON COLUMN country_metadata.vxdel_segment IS
  'An internal grouping as used by BMFG to stratify countries';

