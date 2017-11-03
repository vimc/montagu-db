-- first define the foreign server.  We use placeholders here to
-- substitute in locations so that different testing instances can
-- manipulate the location of the annex.  Another alternative is to
-- use ALTER SERVER, ALTER USER MAPPING to update the connection
-- information.
CREATE EXTENSION postgres_fdw;
CREATE SERVER montagu_db_annex
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host '${montagu_db_annex_host}', port '5432', dbname 'montagu');
CREATE USER MAPPING for vimc
    SERVER montagu_db_annex
    OPTIONS (user 'vimc', password '${montagu_db_annex_password}');

CREATE PUBLICATION sync_burden_estimate_set
    FOR TABLE burden_estimate_set, country, burden_outcome;

CREATE FOREIGN TABLE burden_estimate_stochastic (
        id BIGSERIAL NOT NULL,
        burden_estimate_set integer NOT NULL,
        country text NOT NULL,
        year integer NOT NULL,
        burden_outcome integer NOT NULL,
        stochastic boolean NOT NULL,
        value numeric,
        age integer)
    SERVER montagu_db_annex
    OPTIONS (schema_name 'public', table_name 'burden_estimate_stochastic');
