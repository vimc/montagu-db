CREATE TABLE legal_agreement
(
	name TEXT PRIMARY KEY,
	description TEXT NOT NULL
);

CREATE TABLE user_legal_agreement
(
	legal_agreement TEXT REFERENCES legal_agreement (name),
	username TEXT REFERENCES app_user (username),
	date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO legal_agreement
VALUES ('rfp-applicants-04-18', 'RfP applicants confidentiality agreement April 2018')
