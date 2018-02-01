CREATE TABLE "gavi_eligibility_status" (
  "id" INTEGER,
  "name" TEXT,
  PRIMARY KEY ("id")
);

CREATE TABLE "gavi_eligibility" (
  "id"  SERIAL,
  "touchstone" TEXT,
  "country" TEXT,
  "year" INTEGER,
  "status" INTEGER,
  PRIMARY KEY ("id"),
  FOREIGN KEY (touchstone) REFERENCES touchstone(id),
  FOREIGN KEY (country) REFERENCES country(id),
  FOREIGN KEY (status) REFERENCES gavi_eligibility_status(id),
  UNIQUE ("touchstone", "country", "year")
);

INSERT INTO gavi_eligibility_status (id, name) VALUES
  (0, 'Pre-Gavi eligible'),
  (1, 'Currently eligible'),
  (2, 'Transitioned'),
  (3, 'Never eligible - MIC'),
  (4, 'Never eligible - HIC');
