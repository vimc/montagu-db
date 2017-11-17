-- This is a new table that is not written to yet
-- so we can drop and recreate this column without issue
ALTER TABLE upload_info
DROP COLUMN uploaded_on;

ALTER TABLE upload_info
ADD COLUMN uploaded_on TIMESTAMP;

-- this is similar to burden_estimate_set and allows nice parsing of the date by java
ALTER TABLE upload_info ALTER COLUMN uploaded_on SET DEFAULT date_trunc('milliseconds', now());