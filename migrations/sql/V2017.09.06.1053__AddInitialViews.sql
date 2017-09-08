CREATE OR REPLACE VIEW v_coverage_info AS
SELECT
  scenario.touchstone,
  scenario.scenario_description,
  scenario_description.disease,
  coverage_set.vaccine,
  coverage_set.gavi_support_level,
  coverage_set.activity_type,
  coverage_set.id AS coverage_set_id
FROM coverage_set
  JOIN touchstone
    ON coverage_set.touchstone = touchstone.id
  JOIN scenario_coverage_set
    ON scenario_coverage_set.coverage_set = coverage_set.id
  JOIN scenario
    ON scenario_coverage_set.scenario = scenario.id
  JOIN scenario_description
    ON scenario.scenario_description = scenario_description.id;


CREATE OR REPLACE VIEW v_responsibility_info AS
SELECT
  responsibility_set.touchstone,
  responsibility_set.status,
  scenario.scenario_description,
  scenario_description.disease,
  responsibility.id AS responsibility_id,
  responsibility.current_burden_estimate_set
FROM responsibility_set
  JOIN responsibility
    ON responsibility.responsibility_set = responsibility_set.id
  JOIN scenario
    ON responsibility.scenario = scenario.id
  JOIN scenario_description
    ON scenario.scenario_description = scenario_description.id;
