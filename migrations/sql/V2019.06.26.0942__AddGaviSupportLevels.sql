INSERT INTO gavi_support_level (id, name)
VALUES ('status_quo', 'Basecase status quo: coverage remain at base year coverage')
ON CONFLICT DO NOTHING;
INSERT INTO gavi_support_level (id, name)
VALUES ('continue', 'Continuing trends: historical coverage used to fit natural log function up to 99%')
ON CONFLICT DO NOTHING;
INSERT INTO gavi_support_level (id, name)
VALUES ('gavi_optimistic', 'Assuming optimistic coverage in all gavi supported countries (with <95%)')
ON CONFLICT DO NOTHING;
INSERT INTO gavi_support_level (id, name)
VALUES ('intensified', 'Intensified investment for rapid elimination')
ON CONFLICT DO NOTHING;
