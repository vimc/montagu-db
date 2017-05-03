CREATE UNIQUE INDEX idx_user_username_unique
   ON user (lower(username));

CREATE UNIQUE INDEX idx_user_email_unique
   ON user (lower(email));