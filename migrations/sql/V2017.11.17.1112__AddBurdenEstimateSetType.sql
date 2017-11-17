CREATE TABLE burden_estimate_set_type (
    code TEXT NOT NULL,
    description TEXT NOT NULL,
    is_valid_option BOOLEAN,
    PRIMARY KEY(code)
);
COMMENT ON COLUMN burden_estimate_set_type.is_valid_option 
    IS 'New burden_estimate_set rows should only be created with set types that'
       ' have is_valid_option to true. Those with false are for legacy data';

INSERT INTO burden_estimate_set_type VALUES
    ('central_unknown', 'Central estimates (unknown source)', FALSE),
    ('central_single_run', 'Central estimates (single run)', TRUE),
    ('central_averaged', 'Central estimates (average of stochastic runs)', TRUE),
    ('stochastic', 'Stochastic estimates', TRUE);

ALTER TABLE burden_estimate_set
    ADD COLUMN set_type TEXT NOT NULL DEFAULT 'central_unknown',
    ADD FOREIGN KEY (set_type) REFERENCES burden_estimate_set_type(code),
    ADD COLUMN set_type_details TEXT NULL;

UPDATE burden_estimate_set 
    SET set_type_details = 'Missing data: Predates introduction of set_type';