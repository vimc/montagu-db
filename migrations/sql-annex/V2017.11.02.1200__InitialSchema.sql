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
