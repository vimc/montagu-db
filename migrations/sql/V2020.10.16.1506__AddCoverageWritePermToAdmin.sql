INSERT INTO role_permission VALUES (
    SELECT id FROM role WHERE name = 'admin',
    'coverage.write'
);
