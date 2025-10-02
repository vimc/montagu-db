CREATE TABLE "gavi_support_eligibility_status" (
  "id" INTEGER,
  "name" TEXT,
  PRIMARY KEY ("id")
);

CREATE TABLE "gavi_support_eligibility" (
  "id"  SERIAL,
  "touchstone" TEXT,
  "country" TEXT,
  "year" INTEGER,
  "status" INTEGER,
  PRIMARY KEY ("id"),
  FOREIGN KEY (touchstone) REFERENCES touchstone(id),
  FOREIGN KEY (country) REFERENCES country(id),
  FOREIGN KEY (status) REFERENCES gavi_support_eligibility_status(id),
  UNIQUE ("touchstone", "country", "year")
);

INSERT INTO gavi_support_eligibility_status (id, name) VALUES
  (0, 'fragile'),
  (1, 'poorest'),
  (2, 'intermediate'),
  (3, 'least poor'),
  (4, 'low income'),
  (5, 'graduating'),
  (6, 'initial self-financing'),
  (7, 'preparatory transition phase'),
  (8, 'accelerated transition phase'),
  (9, 'fully self-financing'),
  (10, 'not defined'),
  (11, 'N/A');

