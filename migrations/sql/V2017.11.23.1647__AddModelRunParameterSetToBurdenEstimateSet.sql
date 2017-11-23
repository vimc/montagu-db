ALTER TABLE burden_estimate_set
   ADD COLUMN model_run_parameter_set INTEGER NULl
   ADD FOREIGN KEY (model_run_parameter_set) REFERENCES model_run_parameter_set (id);