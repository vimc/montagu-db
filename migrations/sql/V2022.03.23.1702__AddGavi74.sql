ALTER TABLE country_metadata 
	ADD COLUMN gavi74 BOOLEAN;
UPDATE country_metadata 
	SET gavi74 = FALSE;
ALTER TABLE country_metadata 
	ALTER COLUMN gavi74 SET NOT NULL;

