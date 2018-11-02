DO $$
declare role_id int;
declare member int;
begin
  SELECT id INTO member FROM role WHERE name = 'member';

  -- create new globally scoped 'modeller' role
  INSERT INTO role (name, scope_prefix, description)
  VALUES ('modeller', NULL, 'Modeller')
      RETURNING id
        INTO role_id;

  -- give modellers permission to read modelling groups
  INSERT INTO role_permission values (role_id, 'modelling-groups.read');

  -- make all members of a modelling group also 'modellers'
  INSERT INTO user_group_role (user_group, role, scope_id)
    SELECT user_group, role_id, ''
    FROM user_group_role
    WHERE role = member;

end $$;

