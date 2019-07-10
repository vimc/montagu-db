ALTER TABLE model
    ADD COLUMN gender_specific boolean DEFAULT FALSE,
    ADD COLUMN gender integer DEFAULT NULL,
    ADD FOREIGN KEY (gender) REFERENCES gender (id)
    ;

ALTER TABLE model_version
    ADD COLUMN code text DEFAULT NULL,
    ADD COLUMN is_dynamic boolean DEFAULT FALSE
    ;