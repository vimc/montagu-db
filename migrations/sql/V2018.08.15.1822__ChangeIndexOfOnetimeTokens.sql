ALTER TABLE onetime_token DROP CONSTRAINT onetime_token_pkey;
ALTER TABLE onetime_token ADD COLUMN id SERIAL PRIMARY KEY;

