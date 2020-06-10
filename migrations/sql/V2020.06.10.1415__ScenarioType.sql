CREATE TABLE scenario_type (
  id TEXT NOT NULL ,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE scenario_description
    ADD COLUMN scenario_type TEXT NULL;

ALTER TABLE scenario_description ADD FOREIGN KEY (scenario_type) REFERENCES scenario_type (id);
