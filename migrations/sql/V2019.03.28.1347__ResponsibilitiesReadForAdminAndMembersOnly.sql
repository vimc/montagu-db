-- user role
DELETE FROM role_permision WHERE role=1 AND permission='responsibilities.read';

-- member role
INSERT INTO role_permission VALUES (9, 'responsibilities.read');

-- funder role
INSERT INTO role_permission VALUES (16, 'responsibilities.read');

-- admin role
INSERT INTO role_permission VALUES (17, 'responsibilities.read');

-- developer role
INSERT INTO role_permission VALUES (18, 'responsibilities.read');