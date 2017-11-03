-- Built partly from manually looking at
-- pg_dump -O -x --schema-only -U vimc -d montagu -t burden_estimate


-- NOTE: this table does not have foreign keys.  The reasoning is here:
--
-- https://vimc.myjetbrains.com/youtrack/issue/VIMC-880#comment=97-1574
--
-- > Actually, I think we should just do this without foreign keys!
-- >
-- > Surprising I know but: Currently we have three FK constraints on
-- > burden_estimate : to burden_estimate_set , country and
-- > burden_outcome . Presumably we would have the same on
-- > stochastic_burden_estimate . However, the only code that inserts
-- > data into these tables is the upload a burden estimate endpoint
-- > in the API. The API currently disables all db constraints before
-- > inserting data, and enforces them in the application layer,
-- > before re-enabling the constraints at the end.
-- >
-- > So the constraints are actually never used. Therefore, I think it
-- > makes sense to just not have the constraints on the
-- > stochastic_burden_estimate table, and restrict access so only the
-- > API can write to the table to prevent any rogue SQL scripts
-- > messing things up.
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

CREATE INDEX ON burden_estimate_stochastic (burden_estimate_set);
