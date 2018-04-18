CREATE TABLE confidentiality_agreement
(
	name TEXT PRIMARY KEY,
	description TEXT NOT NULL
);

CREATE TABLE confidentiality_agreement_signature
(
	confidentiality_agreement TEXT REFERENCES confidentiality_agreement (name),
	username TEXT REFERENCES app_user (username),
	date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO confidentiality_agreement
VALUES ('rfp-applicants-04-18', 'RfP applicants confidentiality agreement April 2018')
