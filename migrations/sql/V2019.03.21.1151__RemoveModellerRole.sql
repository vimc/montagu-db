DO $$
declare role_id int;
begin
  SELECT name INTO role_id FROM role WHERE name = 'modeller';

  DELETE FROM user_group_role where role = role_id;
  DELETE FROM role_permission where role = role_id;
  DELETE FROM role where role = role_id;

end $$;