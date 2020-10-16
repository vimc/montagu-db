DO $$
  DECLARE admin_role INT;
BEGIN
  SELECT id INTO admin_role FROM role WHERE name = 'admin';
  INSERT INTO role_permission VALUES (admin_role, 'coverage.write');
END $$;
