CREATE TABLE responsibility_set_comment
(
    id                 SERIAL PRIMARY KEY,
    responsibility_set INTEGER   NOT NULL REFERENCES responsibility_set (id),
    comment            TEXT      NOT NULL,
    added_by           TEXT      NOT NULL REFERENCES app_user (username),
    added_on           TIMESTAMP NOT NULL
);
