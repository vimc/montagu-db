COMMENT ON COLUMN burden_estimate_set_status.code IS 'Valid values: {empty, partial, complete, invalid}';

INSERT INTO burden_estimate_set_status VALUES ('invalid', 'Rows do not match expecations');
INSERT INTO burden_estimate_set_status VALUES ('partial', 'Some but not all burden estimates added');
INSERT INTO burden_estimate_set_status VALUES ('complete', 'Closed to further estimates');
