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
COMMENT ON TABLE gavi_region
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
  fragility text NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY ("country") REFERENCES country (id)
);

CREATE TABLE country_cofinance (
  id SERIAL,
  country TEXT NOT NULL,
  year INTEGER NOT NULL,
  cofinance text NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY ("country") REFERENCES country (id)
);

ALTER TABLE country_metadata
  -- ADD COLUMN francophone INTEGER,
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

COMMENT ON COLUMN country_metadata.vxdel_segment IS
  'An internal grouping as used by BMFG to stratify countries';

CREATE TABLE country_worldbank_status (
  id TEXT NOT NULL
  name TEXT NOT NULL
  PRIMARY KEY (id)
);
COMMENT ON TABLE worldbank_status
  'Country development status according to the worldbank';

-- TODO: add not null constraints throughout
CREATE TABLE country_worldbank_income_status (
  id  SERIAL,
  touchstone TEXT,
  country TEXT,
  year INTEGER,
  worldbank_status TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (touchstone) REFERENCES touchstone(id),
  FOREIGN KEY (country) REFERENCES country(id),
  FOREIGN KEY (worldbank_status) REFERENCES country_worldbank_status(id),
  UNIQUE (touchstone, country, year)
);
