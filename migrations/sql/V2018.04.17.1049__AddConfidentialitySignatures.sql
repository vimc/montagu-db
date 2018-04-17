CREATE TABLE confidentiality_agreement
(
	username TEXT REFERENCES app_user (username),
	date TIMESTAMP,
	signed BOOLEAN
);
