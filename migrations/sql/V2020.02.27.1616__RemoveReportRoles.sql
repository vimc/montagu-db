/* the previous migration has a mis-spelling of the role names so nothing got deleted */
DO $$
    declare reader_id int;
    declare scoped_reader_id int;
    declare reviewer_id int;
begin
    SELECT id INTO reader_id from role where name = 'reports-reader' is null;
    SELECT id INTO scoped_reader_id from role where name = 'reports-reader' is not null;
    SELECT id INTO reviewer_id from role where name = 'reports-reviewer';
    DELETE FROM user_group_role where role = reader_id;
    DELETE FROM user_group_role where role = scoped_reader_id;
    DELETE FROM user_group_role where role = reviewer_id;
    DELETE FROM role where name = 'reports-reader';
    DELETE FROM role where name = 'reports-reviewer';
end $$;
