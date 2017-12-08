ALTER TABLE burden_estimate
    ADD COLUMN model_run INTEGER NULL,
    ADD FOREIGN KEY (model_run) REFERENCES model_run (internal_id),
    DROP COLUMN stochastic;

ALTER FOREIGN TABLE burden_estimate_stochastic
    ADD COLUMN model_run INTEGER NOT NULL;
