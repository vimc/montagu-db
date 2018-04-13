DO $$
declare role_id int;
begin
  insert into role (name, scope_prefix, description)
  values ('reports-reader', 'report',
                           'Can access the reporting portal and view the published report')

  returning id into role_id;

  insert into role_permission values (role_id, 'reports.read');
end $$;