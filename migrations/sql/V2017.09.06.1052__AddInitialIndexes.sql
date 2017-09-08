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
CREATE INDEX ON touchstone_demographic_source(touchstone);

-- api_access_log
CREATE INDEX ON api_access_log (who);
CREATE INDEX ON api_access_log (what);
CREATE INDEX ON api_access_log (timestamp);
CREATE INDEX ON api_access_log (result);
CREATE INDEX ON api_access_log (ip_address);
