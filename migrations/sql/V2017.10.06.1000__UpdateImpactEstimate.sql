-- Add an 'age' column and update the unique constraint to include it
ALTER TABLE impact_estimate
    ADD COLUMN age int DEFAULT NULL
;

-- We are going to want to retrieve all impact estimates from a given set, so
-- let's make that faster
CREATE INDEX ON impact_estimate (impact_estimate_set);

-- NOTE: unlike burden_estimate there is no unique constraint
-- (impact_estimate_set, country, year, age, impact_outcome) but there
-- perhaps should be.
