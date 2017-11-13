CREATE TABLE burden_estimate_set_status (
  code TEXT NOT NULL ,
  description TEXT NOT NULL ,
  PRIMARY KEY (code)
);
COMMENT ON COLUMN burden_estimate_set_status.code IS 'Valid values: {empty, partial, complete}';

INSERT INTO burden_estimate_set_status VALUES ('empty', 'No burden estimates added');
INSERT INTO burden_estimate_set_status VALUES ('partial', 'Some but not all burden estimates added');
INSERT INTO burden_estimate_set_status VALUES ('complete', 'Closed to further estimates');

ALTER TABLE burden_estimate_set
  ADD COLUMN status TEXT DEFAULT 'empty' NULL,
  ADD FOREIGN KEY ("status") REFERENCES burden_estimate_set_status (code);