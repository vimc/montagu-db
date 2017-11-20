ALTER TABLE burden_estimate_set 
    DROP CONSTRAINT burden_estimate_set_set_type_fkey;

UPDATE burden_estimate_set_type SET code = replace(code, '_', '-');
UPDATE burden_estimate_set SET set_type = replace(set_type, '_', '-');

ALTER TABLE burden_estimate_set
    ADD CONSTRAINT burden_estimate_set_set_type_fkey
    FOREIGN KEY (set_type) REFERENCES burden_estimate_set_type(code);
