CREATE TABLE user_group (
  id TEXT NOT NULL,
  name        TEXT NOT NULL,
  description TEXT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE user_group_membership (
  username   TEXT NOT NULL,
  user_group TEXT NOT NULL,
  PRIMARY KEY (username, user_group)
);

ALTER TABLE user_group_membership
  ADD FOREIGN KEY (username) REFERENCES app_user (username);
ALTER TABLE user_group_membership
  ADD FOREIGN KEY (user_group) REFERENCES user_group (id);

CREATE TABLE user_group_role (
user_group TEXT NOT NULL ,
role INTEGER ,
scope_id TEXT NOT NULL ,
PRIMARY KEY (user_group, role, scope_id)
);

ALTER TABLE user_group_role ADD FOREIGN KEY (user_group) REFERENCES user_group (id);
ALTER TABLE user_group_role ADD FOREIGN KEY (role) REFERENCES role (id);

-- create standard groups
INSERT INTO user_group (id, name, description)
VALUES ('gavi', 'GAVI', 'All members of GAVI'),
  ('gates', 'Gates', 'All members of the Gates foundation'),
  ('modellers', 'Modellers', 'Members of modelling groups'),
  ('secretariat', 'Secretariat', 'Members of the consortium secretariat');

