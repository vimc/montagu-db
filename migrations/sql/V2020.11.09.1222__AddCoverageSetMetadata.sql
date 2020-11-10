CREATE TABLE coverage_set_upload_metadata
(
    "id"          SERIAL,
    "uploaded_by" TEXT      NOT NULL REFERENCES app_user (username),
    "uploaded_on" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "filename"    TEXT      NULL,
    "description" TEXT      NOT NULL,
    PRIMARY KEY ("id")
);

ALTER TABLE coverage_set
    ADD COLUMN coverage_set_upload_metadata INTEGER NULL REFERENCES coverage_set_upload_metadata (id);
