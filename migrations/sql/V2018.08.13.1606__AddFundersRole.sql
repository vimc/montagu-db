DO $$
declare role_id int;
begin
  INSERT INTO role (name, scope_prefix, description)
  VALUES ('funder', NULL, 'Funders')
      RETURNING id
        INTO role_id;

  INSERT INTO role_permission values (role_id, 'coverage.read');
  INSERT INTO role_permission values (role_id, 'demographics.read');
end $$;
