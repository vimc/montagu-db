CREATE TABLE burden_estimate_stochastic (
    id BIGSERIAL NOT NULL,
    burden_estimate_set integer NOT NULL,
    country text NOT NULL,
    year integer NOT NULL,
    burden_outcome integer NOT NULL,
    stochastic boolean NOT NULL,
    value numeric,
    age integer,
    PRIMARY KEY ("id")
);

CREATE TABLE burden_estimate_set (
    id SERIAL NOT NULL,
    model_version integer NOT NULL,
    responsibility integer NOT NULL,
    run_info text NOT NULL,
    validation text,
    comment text,
    interpolated boolean NOT NULL,
    complete boolean DEFAULT false NOT NULL,
    uploaded_by text NOT NULL,
    uploaded_on timestamp without time zone DEFAULT date_trunc('milliseconds'::text, now()) NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE country (
    id text NOT NULL,
    name text NOT NULL,
    nid integer,
    PRIMARY KEY ("id")
);

CREATE TABLE burden_outcome (
    id SERIAL NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    PRIMARY KEY ("id")
);

-- WARNING: this is a *total* hack in order to create a
-- non-transactional migration.  The alternative is to set up the
-- subscription during deploy, which might actually be preferable?
--
-- The background is that flyway "autodetects" nontransactional
-- commands and does not yet support CREATE SUBSCRIPTION.
CREATE TYPE public.mytype AS enum ('A');
ALTER TYPE public.mytype ADD VALUE 'B' AFTER 'A';
DROP TYPE public.mytype;

CREATE SUBSCRIPTION sync_burden_estimate_set
    CONNECTION 'dbname=montagu host=${montagu_db_host} user=vimc password=${montagu_db_password}'
    PUBLICATION sync_burden_estimate_set;
