-- Built partly from manually looking at
-- pg_dump -O -x --schema-only -U vimc -d montagu -t burden_estimate

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

-- Foreign key constraints - we're concerned here only with the table
-- that is not replicated from the main database
ALTER TABLE burden_estimate_stochastic
    ADD FOREIGN KEY ("burden_estimate_set")
    REFERENCES burden_estimate_set ("id");
ALTER TABLE burden_estimate_stochastic
    ADD FOREIGN KEY ("country")
    REFERENCES country ("id");
ALTER TABLE burden_estimate_stochastic
    ADD FOREIGN KEY ("burden_outcome")
    REFERENCES burden_outcome ("id");

-- Further logical constraints
ALTER TABLE burden_estimate_stochastic
    ADD CONSTRAINT burden_estimate_stochastic_unique UNIQUE (
        burden_estimate_set,
        country,
        year,
        age,
        burden_outcome
    );

CREATE INDEX ON burden_estimate_stochastic (burden_estimate_set);
