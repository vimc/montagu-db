DO $$
declare role_id int;
begin
  INSERT INTO role (name, scope_prefix, description)
  VALUES ('admin', NULL, 'Consortium admin team')
      RETURNING id
        INTO role_id;

  INSERT INTO role_permission values (role_id, 'coverage.read');
  INSERT INTO role_permission values (role_id, 'touchstones.prepare');
  INSERT INTO role_permission values (role_id, 'reports.read');
end $$;


DO $$
declare role_id int;
begin
  INSERT INTO role (name, scope_prefix, description)
  VALUES ('developer', NULL, 'Consortium tech team')
      RETURNING id
        INTO role_id;

  INSERT INTO role_permission values (role_id, 'coverage.read');
  INSERT INTO role_permission values (role_id, 'touchstones.prepare');
  INSERT INTO role_permission values (role_id, 'reports.read');
end $$;
