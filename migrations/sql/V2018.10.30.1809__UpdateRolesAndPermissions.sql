DELETE FROM role_permisison WHERE role = 1 AND permission IN
('estimates.read',
'modelling-groups.read',
'users.read');
