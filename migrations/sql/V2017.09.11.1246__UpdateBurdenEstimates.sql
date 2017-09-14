-- Add an 'age' column and update the unique constraint to include it
ALTER TABLE burden_estimate 
    ADD COLUMN age int DEFAULT NULL,
    DROP CONSTRAINT burden_estimate_burden_estimate_set_country_year_burden_out_key,
    ADD CONSTRAINT burden_estimate_unique UNIQUE (
        burden_estimate_set, 
        country, 
        year, 
        age, 
        burden_outcome
    )
;

-- We are going to want to retrieve all burden estimates from a given set, so
-- let's make that faster
CREATE INDEX ON burden_estimate (burden_estimate_set);

-- burden_outcome.name for some reason was varchar(25), which is way more 
-- limited than all our other text columns.
ALTER TABLE burden_outcome ALTER COLUMN name SET DATA TYPE TEXT;

-- New outcome codes
INSERT INTO burden_outcome (code, name) VALUES ('cohort_size', 'Cohort size');

-- HepB outcomes
INSERT INTO burden_outcome (code, name) VALUES ('hepb_deaths_acute',       'Deaths due to Hep B acute infection');
INSERT INTO burden_outcome (code, name) VALUES ('hepb_deaths_dec_cirrh',   'Deaths due to Hep B decompensated cirrhosis');
INSERT INTO burden_outcome (code, name) VALUES ('hepb_deaths_hcc',         'Deaths due to Hep B hepatocelular cancer');
INSERT INTO burden_outcome (code, name) VALUES ('hepb_total_cirrh',        'Deaths due to Hep B cirrhosis (compensated and decompensated)');
INSERT INTO burden_outcome (code, name) VALUES ('hepb_cases_acute_severe', 'Cases of Hep B severe acute infection');
INSERT INTO burden_outcome (code, name) VALUES ('hepb_cases_dec_cirrh',    'Cases of Hep B decompensated cirrhosis');
INSERT INTO burden_outcome (code, name) VALUES ('hepb_cases_hcc',          'Cases of Hep B hepatocelular cancer');
INSERT INTO burden_outcome (code, name) VALUES ('hepb_cases_acute_symp',   'Cases of Hep B acute symptomatic infection (moderate and severe)');
