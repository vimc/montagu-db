CREATE TABLE coverage_set_metadata
(
    "id"          INTEGER   NOT NULL,
    "uploaded_by" TEXT      NOT NULL,
    "uploaded_on" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "filename"    TEXT      NULL,
    "description" TEXT      NOT NULL,
    PRIMARY KEY ("id")
);

ALTER TABLE "coverage_set_metadata"
    ADD FOREIGN KEY ("uploaded_by") REFERENCES "app_user" ("username");

ALTER TABLE "coverage_set_metadata"
    ADD FOREIGN KEY ("id") REFERENCES "coverage_set" ("id");
