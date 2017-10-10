-- To carry out new impact calculations we need to indicate if
-- per-year GAVI has supported a given vaccination activity.
ALTER TABLE coverage
    ADD COLUMN gavi_support boolean DEFAULT NULL
    ;
