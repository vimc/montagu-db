DROP FUNCTION IF EXISTS enable_trigger(text, text);
DROP FUNCTION IF EXISTS disable_trigger(text, text);

CREATE FUNCTION enable_trigger(table_name text, trigger_name text)
RETURNS void AS $$ 
BEGIN
    EXECUTE format('ALTER TABLE %I ENABLE TRIGGER %I', table_name, trigger_name);
END $$
LANGUAGE plpgsql
SECURITY DEFINER;

CREATE FUNCTION disable_trigger(table_name text, trigger_name text)
RETURNS void AS $$ 
BEGIN
    EXECUTE format('ALTER TABLE %I DISABLE TRIGGER %I', table_name, trigger_name);
END $$
LANGUAGE plpgsql
SECURITY DEFINER;
