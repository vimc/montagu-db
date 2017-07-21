CREATE UNIQUE INDEX idx_user_username_unique 
    ON app_user (lower(username));

CREATE UNIQUE INDEX idx_user_email_unique 
    ON app_user (lower(email));

-- The demographic_statistic table gets very large so we need to index
-- a few things to make it possible to index efficiently.
-- Unfortunately this also makes inserts very slow!
CREATE INDEX ON demographic_statistic (demographic_variant);
CREATE INDEX ON demographic_statistic (gender);
CREATE INDEX ON demographic_statistic (country);
CREATE INDEX ON demographic_statistic (demographic_statistic_type);
CREATE INDEX ON demographic_statistic (demographic_source);
