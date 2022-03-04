CREATE OR REPLACE VIEW burden AS
SELECT touchstone.touchstone_name,
  responsibility_set.touchstone,
  responsibility_set.modelling_group,
  scenario_description.description AS scenario_description,
  disease.name AS disease_name,
  burden_outcome.code AS outcome_code,
  country.id AS country,
  burden_estimate.value,
  burden_estimate.year,
  burden_estimate.age
FROM responsibility_set
  JOIN modelling_group ON modelling_group.id = responsibility_set.modelling_group
  JOIN responsibility ON responsibility_set.id = responsibility.responsibility_set
  JOIN burden_estimate_set ON burden_estimate_set.id = responsibility.current_burden_estimate_set
  JOIN scenario ON scenario.id = responsibility.scenario
  JOIN scenario_description ON scenario_description.id = scenario.scenario_description
  JOIN disease ON disease.id = scenario_description.disease
  JOIN burden_estimate ON burden_estimate.burden_estimate_set = burden_estimate_set.id
  JOIN burden_outcome ON burden_outcome.id = burden_estimate.burden_outcome
  JOIN country ON country.nid = burden_estimate.country
  JOIN touchstone ON responsibility_set.touchstone = touchstone.id
WHERE responsibility.is_open;


CREATE OR REPLACE VIEW burden_all AS
SELECT touchstone.touchstone_name,
  responsibility_set.touchstone,
  responsibility_set.modelling_group,
  scenario_description.description AS scenario_description,
  disease.name AS disease_name,
  burden_outcome.code AS outcome_code,
  country.id AS country,
  burden_estimate.value,
  burden_estimate.year,
  burden_estimate.age
FROM responsibility_set
  JOIN modelling_group ON modelling_group.id = responsibility_set.modelling_group
  JOIN responsibility ON responsibility_set.id = responsibility.responsibility_set
  JOIN burden_estimate_set ON burden_estimate_set.id = responsibility.current_burden_estimate_set
  JOIN scenario ON scenario.id = responsibility.scenario
  JOIN scenario_description ON scenario_description.id = scenario.scenario_description
  JOIN disease ON disease.id = scenario_description.disease
  JOIN burden_estimate ON burden_estimate.burden_estimate_set = burden_estimate_set.id
  JOIN burden_outcome ON burden_outcome.id = burden_estimate.burden_outcome
  JOIN country ON country.nid = burden_estimate.country
  JOIN touchstone ON responsibility_set.touchstone = touchstone.id;