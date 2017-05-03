CREATE UNIQUE INDEX idx_user_username_unique 
    ON app_user (lower(username));

CREATE UNIQUE INDEX idx_user_email_unique 
    ON app_user (lower(email));
