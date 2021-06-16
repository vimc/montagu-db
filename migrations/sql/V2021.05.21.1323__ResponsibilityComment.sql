CREATE TABLE responsibility_comment
(
    id             SERIAL PRIMARY KEY,
    responsibility INTEGER   NOT NULL REFERENCES responsibility (id),
    comment        TEXT      NOT NULL,
    added_by       TEXT      NOT NULL REFERENCES app_user (username),
    added_on       TIMESTAMP NOT NULL
);
