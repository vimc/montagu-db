DELETE FROM role_permission WHERE role = 1 AND permission IN
('estimates.read',
'modelling-groups.read',
'users.read');

declare admin int;
SELECT id FROM role INTO admin WHERE name = 'admin';

declare developer int;
SELECT id FROM role INTO developer WHERE name = 'developer';

declare member int;
SELECT id FROM role INTO member WHERE name = 'member';

INSERT INTO role_permission VALUES (admin, 'estimates.read')
INSERT INTO role_permission VALUES (admin, 'modelling-groups.read')
INSERT INTO role_permission VALUES (admin, 'users.read')

INSERT INTO role_permission VALUES (developer, 'estimates.read')
INSERT INTO role_permission VALUES (developer, 'modelling-groups.read')
INSERT INTO role_permission VALUES (developer, 'users.read')

INSERT INTO role_permission VALUES (member, 'estimates.read')
INSERT INTO role_permission VALUES (member, 'modelling-groups.read')
INSERT INTO role_permission VALUES (member, 'users.read')
