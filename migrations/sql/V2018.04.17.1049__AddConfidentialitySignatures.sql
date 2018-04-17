CREATE TABLE confidentiality_agreement
(
	username TEXT REFERENCES app_user (username),
	date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
