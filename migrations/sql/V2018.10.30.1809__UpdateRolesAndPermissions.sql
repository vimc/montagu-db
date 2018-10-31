DELETE FROM role_permission
WHERE role = 1
AND permission IN ('estimates.read',
                           'modelling-groups.read',
                           'users.read');


DO $$
  declare admin int;
  declare developer int;
  declare member int;
begin
  SELECT id INTO admin FROM role WHERE name = 'admin';
  SELECT id INTO developer FROM role WHERE name = 'developer';
  SELECT id INTO member FROM role WHERE name = 'member';

  INSERT INTO role_permission VALUES (admin, 'estimates.read');
  INSERT INTO role_permission VALUES (admin, 'modelling-groups.read');
  INSERT INTO role_permission VALUES (admin, 'users.read');

  INSERT INTO role_permission VALUES (developer, 'estimates.read');
  INSERT INTO role_permission VALUES (developer, 'modelling-groups.read');
  INSERT INTO role_permission VALUES (developer, 'users.read');

  INSERT INTO role_permission VALUES (member, 'estimates.read');
  INSERT INTO role_permission VALUES (member, 'modelling-groups.read');
  INSERT INTO role_permission VALUES (member, 'users.read');

end $$;