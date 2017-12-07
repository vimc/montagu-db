ALTER TABLE burden_estimate_stochastic
    /* Note lack of FK; this is deliberate */
    ADD COLUMN model_run INTEGER NULL;
