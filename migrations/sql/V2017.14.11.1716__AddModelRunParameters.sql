CREATE TABLE upload_info(
id SERIAL,
uploaded_by TEXT NOT NULL,
uploaded_on TEXT NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE model_run_parameter_set(
   id SERIAL,
   responsibility_set INTEGER NOT NULL,
   description TEXT,
   upload_info INTEGER NOT NULL,
   model_version INTEGER NOT NULL,
   PRIMARY KEY (id)
);

ALTER TABLE model_run_parameter_set ADD FOREIGN KEY (responsibility_set) REFERENCES responsibility_set (id);
ALTER TABLE model_run_parameter_set ADD FOREIGN KEY (model_version) REFERENCES model_version (id);
ALTER TABLE model_run_parameter_set ADD FOREIGN KEY (upload_info) REFERENCES upload_info (id);

CREATE TABLE model_run(
internal_id SERIAL,
run_id TEXT NOT NULL,
model_run_parameter_set INTEGER NOT NULL,
PRIMARY KEY (internal_id)
);

ALTER TABLE model_run ADD FOREIGN KEY (model_run_parameter_set) REFERENCES model_run_parameter_set (id);

CREATE TABLE model_run_parameter(
model_run INTEGER NOT NULL,
key TEXT NOT NULL,
value TEXT NOT NULL,
UNIQUE (key, model_run)
);

ALTER TABLE model_run_parameter ADD FOREIGN KEY (model_run) REFERENCES model_run (internal_id);