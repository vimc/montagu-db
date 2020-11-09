CREATE TABLE coverage_set_metadata
(
    "id"          SERIAL,
    "uploaded_by" TEXT      NOT NULL,
    "uploaded_on" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "filename"    TEXT      NULL,
    "description" TEXT      NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE coverage_set_coverage_set_metadata
(
    "coverage_set"          INTEGER   NOT NULL,
    "coverage_set_metadata" INTEGER      NOT NULL
);

ALTER TABLE "coverage_set_metadata"
    ADD FOREIGN KEY ("uploaded_by") REFERENCES "app_user" ("username");

ALTER TABLE "coverage_set_coverage_set_metadata"
    ADD FOREIGN KEY ("coverage_set") REFERENCES "coverage_set" ("id");

ALTER TABLE "coverage_set_coverage_set_metadata"
    ADD FOREIGN KEY ("coverage_set_metadata") REFERENCES "coverage_set_metadata" ("id");
