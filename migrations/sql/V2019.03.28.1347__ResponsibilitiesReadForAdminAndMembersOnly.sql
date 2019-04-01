DO $$
  DECLARE user_role INT;
  DECLARE member_role INT;
  DECLARE funder_role INT;
  DECLARE admin_role INT;
  DECLARE developer_role INT;
BEGIN
  SELECT id INTO user_role FROM role WHERE name = 'user'
  SELECT id INTO member_role FROM role WHERE name = 'member'
  SELECT id INTO funder_role FROM role WHERE name = 'funder'
  SELECT id INTO admin_role FROM role WHERE name = 'admin'
  SELECT id INTO developer_role FROM role WHERE name = 'developer'

  DELETE FROM role_permission WHERE role=user_role AND permission='responsibilities.read';

  INSERT INTO role_permission VALUES (member_role, 'responsibilities.read');
  INSERT INTO role_permission VALUES (funder_role, 'responsibilities.read');
  INSERT INTO role_permission VALUES (admin_role, 'responsibilities.read');
  INSERT INTO role_permission VALUES (devleoper_role, 'responsibilities.read');
END $$;