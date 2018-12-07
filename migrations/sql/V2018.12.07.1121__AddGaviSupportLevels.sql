INSERT INTO gavi_support_level (id, name)
VALUES ('high', 'Assuming 10% above OP coverage')
ON CONFLICT DO NOTHING;
INSERT INTO gavi_support_level (id, name)
 VALUES ('low', 'Assuming 10% below OP coverage')
ON CONFLICT DO NOTHING;
INSERT INTO gavi_support_level (id, name)
VALUES ('bestcase', 'BMGF best case scenario: assuming best coverage for future(90%/95%/histotical highest)')
ON CONFLICT DO NOTHING;

-- these already exist on prod, so updating the wording here as the prev inserts won't happen
UPDATE gavi_support_level
SET name = 'BMGF best case scenario: assuming best coverage for future(90%/95%/historical highest)'
WHERE id = 'bestcase';

UPDATE gavi_support_level
SET name = 'Assuming 10% below OP coverage'
WHERE id = 'low';

UPDATE gavi_support_level
SET name = 'Assuming 10% above OP coverage'
WHERE id = 'high';
