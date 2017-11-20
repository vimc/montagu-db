-- This extension is built into postgres and needs no installation
CREATE EXTENSION postgres_fdw;

-- First define the foreign server.  We use placeholders here to
-- substitute in locations so that different testing instances can
-- manipulate the location of the annex.  Another alternative is to
-- use ALTER SERVER, ALTER USER MAPPING to update the connection
-- information.
CREATE SERVER montagu_db_annex
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (
        host '${montagu_db_annex_host}',
        port '${montagu_db_annex_port}',
        dbname 'montagu');

-- This is a mapping for the main montagu root user onto a user in the
-- annex; it is the only mapping that will map through to a read-write
-- user (that can be changed by altering the usernames passed through
-- to flyway).
--
-- The deploy script will map all of montagu's actual db users (api,
-- readonly, orderly, ...) through to the annex's readonly user.
CREATE USER MAPPING for vimc
    SERVER montagu_db_annex
    OPTIONS (
        user 'readonly',
        password '${montagu_db_annex_password}');

-- The actual table that we want to access.
--
-- This will need updating as the schema solidifies around the
-- stochastic burden estimates.  It must reflect the copy in the
-- annex.  We can do this directly at the cost of making a connection
-- and I might move to doing that.
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
