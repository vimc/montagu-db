INSERT INTO gavi_support_level (id, name)
VALUES ('high', 'Assuming 10% above OP coverage')
ON CONFLICT DO NOTHING;
INSERT INTO gavi_support_level (id, name)
 VALUES ('low', 'Assuming 10% below OP coverage')
ON CONFLICT DO NOTHING;
INSERT INTO gavi_support_level (id, name)
VALUES ('bestcase', 'BMGF best case scenario: assuming best coverage for future(90%/95%/histotical highest)')
ON CONFLICT DO NOTHING;

UPDATE gavi_support_level
SET name = 'BMGF best case scenario: assuming best coverage for future(90%/95%/historical highest)'
WHERE id = 'bestcase';
