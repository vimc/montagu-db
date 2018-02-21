CREATE TABLE user_group (
  "name"        TEXT NOT NULL,
  "description" TEXT NULL,
  PRIMARY KEY ("name")
);

CREATE TABLE user_group_user (
  username   TEXT NOT NULL,
  user_group TEXT NOT NULL,
  PRIMARY KEY (username, user_group)
);

CREATE TABLE user_group_role (
"user_group" TEXT NOT NULL ,
"role" INTEGER ,
"scope_id" TEXT NOT NULL ,
PRIMARY KEY ("user_group", "role", "scope_id")
);

ALTER TABLE user_group_user
  ADD FOREIGN KEY (username) REFERENCES app_user (username);
ALTER TABLE user_group_user
  ADD FOREIGN KEY (user_group) REFERENCES user_group (name);

INSERT INTO user_group (name, description)
VALUES ('GAVI', 'All members of GAVI'),
  ('Gates', 'All members of the Gates foundation'),
  ('Modellers', 'Members of modelling groups'),
  ('Secretariat', 'Members of the consortium secretariat');

-- for each user create group of same name
INSERT INTO user_group (name, description)
  SELECT username, 'Individual user group'
  FROM app_user;

-- insert all modellers into Modellers group
INSERT INTO user_group_user (username, user_group)
  SELECT username, 'Modellers'
  FROM user_role
  WHERE role = 9;
