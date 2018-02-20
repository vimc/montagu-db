ALTER TABLE burden_estimate
  ADD COLUMN country_nid SMALLINT NULL;

ALTER TABLE burden_estimate
ADD CONSTRAINT burden_estimate_country_nid
FOREIGN KEY (country_nid) REFERENCES country (nid);
