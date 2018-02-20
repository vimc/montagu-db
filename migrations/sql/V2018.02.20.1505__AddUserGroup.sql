CREATE TABLE report_user_group (
  "name"        TEXT NOT NULL,
  "description" TEXT NULL,
  PRIMARY KEY ("name")
);

CREATE TABLE user_report_user_group (
  username   TEXT NOT NULL,
  user_group TEXT NOT NULL,
  PRIMARY KEY (username, user_group)
);

ALTER TABLE user_report_user_group
  ADD FOREIGN KEY (username) REFERENCES app_user (username);
ALTER TABLE user_report_user_group
  ADD FOREIGN KEY (user_group) REFERENCES report_user_group (name);

INSERT INTO report_user_group (name, description)
VALUES ('GAVI', 'All members of GAVI'),
  ('Gates', 'All members of the Gates foundation'),
  ('Modellers', 'Members of modelling groups'),
  ('Secretariat', 'Members of the consortium secretariat');

-- insert all modellers into modelling group
INSERT INTO user_report_user_group (username, user_group)
  SELECT (username, 'Modellers')
  FROM user_role
  WHERE role = 'member';