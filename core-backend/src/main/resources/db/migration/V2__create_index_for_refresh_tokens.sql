CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);

ALTER TABLE refresh_tokens RENAME COLUMN expired_date to expires_at;

ALTER TABLE refresh_tokens
    ADD COLUMN revoked BOOLEAN DEFAULT false;

ALTER TABLE users ADD COLUMN updated_at TIMESTAMP;
ALTER TABLE refresh_tokens ADD COLUMN updated_at TIMESTAMP;
