-- To carry out new impact calculations we need to indicate
-- percentage of GAVI support in a given vaccination activity.
ALTER TABLE coverage
    ADD COLUMN percent_gavi_support DOUBLE PRECISION DEFAULT NULL
    ;
