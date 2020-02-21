DO $$
    declare reader_id int;
    declare reviewer_id int;
begin
    SELECT id INTO reader_id from role where name = 'reports.reader';
    SELECT id INTO reviewer_id from role where name = 'reports.reviewer';
    DELETE FROM role_permission where permission = 'reports.read';
    DELETE FROM role_permission where permission = 'reports.review';
    DELETE FROM role_permission where permission = 'reports.run';
    DELETE FROM permission where name = 'reports.read';
    DELETE FROM permission where name = 'reports.review';
    DELETE FROM permission where name = 'reports.run';
    DELETE FROM user_group_role where role = reader_id;
    DELETE FROM user_group_role where role = reviewer_id;
    DELETE FROM role where name = 'reports.reader';
    DELETE FROM role where name = 'reports.reviewer';
end $$;
