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
  'Some description of a gavi region';

-- it's possible that what is wanted here is not just this but also
-- some sort of mega region thing, dividing the world up as
-- "Africa"/"Indo pacific" etc.
CREATE TABLE country_continent (
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  PRIMARY KEY (id))

CREATE TABLE country_disease_endemic (
  country TEXT  NOT NULL,
  disease TEXT  NOT NULL,
  FOREIGN KEY ("country") REFERENCES country (id),
  FOREIGN KEY ("disease") REFERENCES disease (id));

CREATE TABLE country_fragility (
  id SERIAL,
  country TEXT NOT NULL,
  year INTEGER NOT NULL,
  fragile BOOLEAN NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY ("country") REFERENCES country (id)
);

CREATE TABLE country_cofinance (
  id SERIAL,
  country TEXT NOT NULL,
  year INTEGER NOT NULL,
  cofinance BOOLEAN NOT NULL,
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

  ADD COLUMN continent TEXT NOT NULL,
  ADD FOREIGN KEY ("continent") REFERENCES country_continent (id),

  -- Xiang to think about:
  -- ADD COLUMN continental_africa_gavi_supported BOOLEAN NOT NULL,
  -- ADD COLUMN indo_pacific BOOLEAN NOT NULL,
  -- ADD COLUMN regional_je BOOLEAN NOT NULL,
  -- ADD COLUMN regional_mena BOOLEAN NOT NULL,
  -- ADD COLUMN regional_yfv BOOLEAN NOT NULL,

COMMENT ON COLUMN country_metadata.vxdel_segment IS
  'An internal grouping as used by BMFG to stratify countries';

COMMENT ON COLUMN country_metadata.regional_je IS
  'In this country JE is considered to be present?';
COMMENT ON COLUMN country_metadata.regional_mena IS
  'In this country MenA is considered to be present?';
COMMENT ON COLUMN country_metadata.regional_yf IS
  'In this country yellow fever is considered to be present?';


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
