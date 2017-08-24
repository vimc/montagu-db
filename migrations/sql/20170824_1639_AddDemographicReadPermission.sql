do $$
    declare user_role_id integer;
begin
    insert into permission (name) 
    values ('demographics.read');

    select id into user_role_id from role where role.name='user';

    insert into role_permission (role, permission)
    values (user_role_id, 'demographics.read');
end $$;