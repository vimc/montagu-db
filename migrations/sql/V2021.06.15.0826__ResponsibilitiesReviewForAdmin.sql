DO
$$
    DECLARE
        admin_role_id INT;
    BEGIN
        INSERT INTO permission VALUES ('responsibilities.review');
        SELECT id INTO admin_role_id FROM role WHERE name = 'admin';
        INSERT INTO role_permission VALUES (admin_role_id, 'responsibilities.review');
    END
$$;
