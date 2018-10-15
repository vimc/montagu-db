-- NOTE for review:
--
-- does it makes sense to prefix these tables with country_ or not?
-- check null ness for everything
-- everything that needs to be an enum table done
-- no "data" in column names (e.g., thing_2008, thing_yf, etc)
-- some of the not-null constraints need to be relaxed until we have the data import done - this needs writing out as a second import.


CREATE TABLE gavi_region (
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  PRIMARY KEY (id)
);
COMMENT ON TABLE gavi_region
  'include four types of gavi region interested by gavi donors';

CREATE TABLE country_disease_endemic (
  id SERIAL,
  touchstone TEXT NOT NULL,
  country TEXT  NOT NULL,
  disease TEXT  NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (touchstone) REFERENCES touchstone(id),
  FOREIGN KEY (country) REFERENCES country(id),
  FOREIGN KEY (disease) REFERENCES disease(id)
);

CREATE TABLE country_fragility (
  id SERIAL,
  touchstone TEXT NOT NULL,
  country TEXT NOT NULL,
  year INTEGER NOT NULL,
  is_fragile BOOLEAN NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (touchstone) REFERENCES touchstone(id),
  FOREIGN KEY (country) REFERENCES country(id)
);

CREATE TABLE cofinance_status (
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE country_cofinance (
  id SERIAL,
  touchstone TEXT NOT NULL,
  country TEXT NOT NULL,
  year INTEGER NOT NULL,
  cofinance_status text NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (touchstone) REFERENCES touchstone(id),
  FOREIGN KEY (country) REFERENCES country(id)
  FOREIGN KEY (cofinance_status) REFERENCES cofinance_status(id)
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

CREATE TABLE francophone_status (
  id TEXT,
  PRIMARY KEY (status)
);
COMMENT ON TABLE francophone_status
  'Status within the Organisation internationale de la Francophonie';

ALTER TABLE country_metadata
  ADD COLUMN francophone TEXT,
  ADD COLUMN vxdel_segement TEXT,
  ADD COLUMN pine_5 BOOLEAN,
  ADD COLUMN dove94 BOOLEAN,
  ADD COLUMN gavi68 BOOLEAN,
  ADD COLUMN gavi72 BOOLEAN,
  ADD COLUMN gavi77 BOOLEAN,
  ADD COLUMN dove96 BOOLEAN,
  ADD COLUMN gavi_region TEXT,
  FOREIGN KEY (gavi_region) REFERENCES gavi_region(id),
  FOREIGN KEY (francophone) REFERENCES francophone_status(id),
  ADD COLUMN gavi_pef_type TEXT;

COMMENT ON COLUMN country_metadata.francophone IS
  '28 Gavi-supported French-speaking countries of interest to Gavi donors + 1 associated member + 4 observer counrties';

COMMENT ON COLUMN country_metadata.vxdel_segment IS
  'An internal grouping as used by BMFG to stratify countries';

COMMENT ON COLUMN country_metadata.gavi_pef_type IS
  'Gavi Partners engagement framework';

