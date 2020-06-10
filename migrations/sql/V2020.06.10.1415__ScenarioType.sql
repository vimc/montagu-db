CREATE TABLE scenario_type (
  id TEXT NOT NULL ,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

-- create types
INSERT INTO scenario_type (id, name)
VALUES
  ('novac', 'VIMC no-vaccination counterfactual scenario'),
  ('default-high', 'VIMC default scenario with coverage 10% above forecast'),
  ('default-low', 'VIMC default scenario with coverage 10% below forecast'),
  ('default-high-transm', 'VIMC default scenario with high disease transmission'),
  ('default-low-transm', 'VIMC default scenario with low disease transmission'),
  ('default-best', 'VIMC default scenario with out-of-facility support'),
  ('default-best-high-transm', 'VIMC default scenario with out-of-facility support and high disease transmission'),
  ('default-best-low-transm', 'VIMC default scenario with out-of-facility support and low disease transmission'),
  ('pre-gavi', 'VIMC scenarios without GAVI support'),
  ('2010-levels', '*Pre VIMC scenario type. Information pending.*'),
  ('default', 'VIMC default scenario'),
  ('bestcase', 'BMGF bestcase scenario'),
  ('stop', 'VIMC stop scenario'),
  ('covid-scenario1', 'VPDS-COVID business as usual scenario 1'),
  ('covid-scenario1-portnoy', 'VPDS-COVID business as usual scenario 1 - Portnoy CFRs'),
  ('covid-scenario1-wolfson', 'VPDS-COVID business as usual scenario 1 - Wolfson CFRs'),
  ('covid-scenario2', 'VPDS-COVID with disruption scenario 2'),
  ('covid-scenario2-portnoy', 'VPDS-COVIDwith disruption scenario 2 - Portnoy CFRs'),
  ('covid-scenario2-wolfson', 'VPDS-COVID with disruption scenario 2 - Wolfson CFRs'),
  ('covid-scenario3', 'VPDS-COVID with disruption scenario 3'),
  ('covid-scenario3-portnoy', 'VPDS-COVIDwith disruption scenario 3 - Portnoy CFRs'),
  ('covid-scenario3-wolfson', 'VPDS-COVID with disruption scenario 3 - Wolfson CFRs'),
  ('covid-scenario4', 'VPDS-COVID with disruption scenario 4'),
  ('covid-scenario4-portnoy', 'VPDS-COVIDwith disruption scenario 4 - Portnoy CFRs'),
  ('covid-scenario4-wolfson', 'VPDS-COVID with disruption scenario 4 - Wolfson CFRs'),
  ('covid-scenario5', 'VPDS-COVID with disruption scenario 5'),
  ('covid-scenario5-portnoy', 'VPDS-COVIDwith disruption scenario 5 - Portnoy CFRs'),
  ('covid-scenario5-wolfson', 'VPDS-COVID with disruption scenario 5 - Wolfson CFRs'),
  ('covid-scenario6', 'VPDS-COVID with disruption scenario 6'),
  ('covid-scenario6-portnoy', 'VPDS-COVIDwith disruption scenario 6 - Portnoy CFRs'),
  ('covid-scenario6-wolfson', 'VPDS-COVID with disruption scenario 6 - Wolfson CFRs'),
  ('covid-scenario7', 'VPDS-COVID with disruption scenario 7'),
  ('covid-scenario7-portnoy', 'VPDS-COVIDwith disruption scenario 7 - Portnoy CFRs'),
  ('covid-scenario7-wolfson', 'VPDS-COVID with disruption scenario 7 - Wolfson CFRs'),
  ('covid-scenario8', 'VPDS-COVID with disruption scenario 8'),
  ('covid-scenario8-portnoy', 'VPDS-COVIDwith disruption scenario 8 - Portnoy CFRs'),
  ('covid-scenario8-wolfson', 'VPDS-COVID with disruption scenario 8 - Wolfson CFRs'),
  ('covid-scenario9', 'VPDS-COVID with disruption scenario 9'),
  ('covid-scenario9-portnoy', 'VPDS-COVIDwith disruption scenario 9 - Portnoy CFRs'),
  ('covid-scenario9-wolfson', 'VPDS-COVID with disruption scenario 9 - Wolfson CFRs'),
  ('covid-scenario10-portnoy', 'VPDS-COVIDwith disruption scenario 10 - Portnoy CFRs'),
  ('covid-scenario10-wolfson', 'VPDS-COVID with disruption scenario 10 - Wolfson CFRs');

ALTER TABLE scenario_description
    ADD COLUMN scenario_type TEXT NULL;

ALTER TABLE scenario_description ADD FOREIGN KEY (scenario_type) REFERENCES scenario_type (id);
