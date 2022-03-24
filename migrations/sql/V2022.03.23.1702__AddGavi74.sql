ALTER TABLE country_metadata
    ADD COLUMN gavi74 BOOLEAN default FALSE,
    ALTER COLUMN gavi74 SET NOT NULL;

