DELETE FROM model_version WHERE model = 'unknown';
DELETE FROM model WHERE id = 'unknown';

ALTER TABLE modelling_group
    RENAME COLUMN current to replaced_by;

ALTER TABLE model
    DROP COLUMN current,
    ADD COLUMN is_current boolean NOT NULL DEFAULT FALSE,
    ADD COLUMN current_version serial REFERENCES model_version (id),
    ADD COLUMN disease text REFERENCES disease (id);

-- Add disease information to models
UPDATE model SET disease = 'HepB' WHERE id in 
    ('HepBGoldstein', 'HepBIC', 'HepBSTATIC', 'PRoGReSs');
UPDATE model SET disease = 'Hib' WHERE id in
    ('LiST-Hib', 'TRIVAC-Hib');
UPDATE model SET disease = 'HPV' WHERE id in
    ('PRIME', 'HPVGoldie', 'HPVGoldie-flat', 'HPVGoldie-linear');
UPDATE model SET disease = 'JE' WHERE id in 
    ('JE-Clapham', 'PATH-JE');
UPDATE model SET disease = 'Measles' WHERE id in 
    ('DynaMICE', 'MeaslesPSU');
UPDATE model SET disease = 'MenA' WHERE id in
    ('MenA-Cambridge', 'MenAJackson', 'PATH-MenA');
UPDATE model SET disease = 'PCV' WHERE id in
    ('LiST-PCV', 'TRIVAC-PCV');
UPDATE model SET disease = 'Rota' WHERE id in
    ('LiST-Rota', 'TRIVAC-Rota');
UPDATE model SET disease = 'Rubella' WHERE id in
    ('RubellaPHE');
UPDATE model SET disease = 'YF' WHERE id in
    ('UnknownYF', 'YFIC');

-- Add is_current information to models
UPDATE model SET is_current = TRUE;
UPDATE model SET is_current = FALSE WHERE modelling_group IN 
    ('unknown', 'Harvard-Sweet', 'LSHTM-Edmunds');
UPDATE model SET is_current = FALSE WHERE id IN 
    ('PATH-MenA');
-- This is the only modelling group that has more than one model for the same
-- disease. I've just picked one of three models at random - we need Tini on
-- this one.
UPDATE model SET is_current = TRUE 
    WHERE modelling_group = 'Harvard-Sweet'
    and id = 'HPVGoldie';

-- Create a new version for every model
WITH inserted_versions AS (
    INSERT INTO model_version (model, version, note)
    SELECT model.id, '201708test', 
        'Generated automatically - we have not gathered any information about '
        'what versions the groups used in this touchstone'
    FROM model
    WHERE model.is_current
    RETURNING model_version.id, model_version.model
)
UPDATE model
SET current_version = inserted_versions.id
FROM inserted_versions
WHERE model.id = inserted_versions.model;

-- Add not null constraint to model.disease
ALTER TABLE model ALTER COLUMN disease SET NOT NULL;

-- Add conditional unique constraint to model
CREATE UNIQUE INDEX modelling_group_disease_unique_when_current ON
    model (modelling_group, disease) WHERE (is_current);