CREATE UNIQUE INDEX CONCURRENTLY onetime_token_pkey_temp ON onetime_token (md5(token));
ALTER TABLE onetime_token DROP CONSTRAINT onetime_token_pkey,
	ADD CONSTRAINT onetime_token_pkey PRIMARY KEY USING INDEX onetime_token_pkey_temp;
