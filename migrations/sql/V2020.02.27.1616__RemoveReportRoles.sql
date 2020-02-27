/* the previous migration has a mis-spelling of the role names so nothing got deleted */
DO $$
    declare reader_id int;
    declare reviewer_id int;
begin
    SELECT id INTO reader_id from role where name = 'reports-reader';
    SELECT id INTO reviewer_id from role where name = 'reports-reviewer';
    DELETE FROM user_group_role where role = reader_id;
    DELETE FROM user_group_role where role = reviewer_id;
    DELETE FROM role where name = 'reports-reader';
    DELETE FROM role where name = 'reports-reviewer';
end $$;
