-- create identity groups
INSERT INTO user_group (id, name, description)
SELECT username, username, '' from app_user
ON CONFLICT DO NOTHING;

-- add users to their identity groups
INSERT INTO user_group_membership (username, user_group)
  SELECT username, username from app_user
ON CONFLICT DO NOTHING;

-- migrate roles
INSERT INTO user_group_role (user_group, role, scope_id)
  SELECT username, role, scope_id from user_role
ON CONFLICT DO NOTHING;
