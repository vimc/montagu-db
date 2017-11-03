-- WARNING: this is a *total* hack in order to create a
-- non-transactional migration.  The alternative is to set up the
-- subscription during deploy, which might actually be preferable?
--
-- The background is that flyway "autodetects" nontransactional
-- commands and does not yet support CREATE SUBSCRIPTION.
CREATE TYPE public.mytype AS enum ('A');
ALTER TYPE public.mytype ADD VALUE 'B' AFTER 'A';
DROP TYPE public.mytype;

-- It may be worthwhile setting the option 'synchronous_commit' to
-- 'on' by adding the line
--
--   WITH (synchronous_commit = on)
--
-- at the end of the CREATE SUBSCRIPTION block here.  We can also
-- change this later with ALTER SUBSCRIPTION.
--
-- https://www.postgresql.org/docs/10/static/sql-createsubscription.html
-- https://www.postgresql.org/docs/10/static/runtime-config-wal.html#guc-synchronous-commit
CREATE SUBSCRIPTION sync_burden_estimate_set
    CONNECTION 'dbname=montagu host=${montagu_db_host} user=vimc password=${montagu_db_password}'
    PUBLICATION sync_burden_estimate_set;
