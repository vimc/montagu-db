ALTER TABLE upload_info
DROP COLUMN uploaded_on;

ALTER TABLE upload_info
ADD COLUMN uploaded_on SET DATA TYPE TIMESTAMP;