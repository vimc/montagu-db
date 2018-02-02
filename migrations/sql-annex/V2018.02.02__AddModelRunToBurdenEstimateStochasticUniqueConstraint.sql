ALTER TABLE burden_estimate_stochastic
    DROP CONSTRAINT burden_estimate_stochastic_unique,
    ADD CONSTRAINT burden_estimate_stochastic_unique UNIQUE (
        burden_estimate_set,
        model_run,
        country,
        year,
        age,
        burden_outcome
    ) DEFERRABLE INITIALLY DEFERRED;
