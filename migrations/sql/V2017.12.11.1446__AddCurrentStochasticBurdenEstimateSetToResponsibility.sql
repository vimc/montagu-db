ALTER TABLE responsibility
	ADD COLUMN current_stochastic_burden_estimate_set INTEGER NULL,
	ADD FOREIGN KEY (current_stochastic_burden_estimate_set) REFERENCES burden_estimate_set (id);
