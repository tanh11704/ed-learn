CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Kiểm tra xem type đã tồn tại chưa để tránh lỗi khi chạy lại
DO $$ BEGIN
    CREATE TYPE role_type AS ENUM ('ADMIN', 'USER');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role role_type DEFAULT 'USER',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL, -- Dùng luôn tên chuẩn, không cần RENAME
    device_info VARCHAR(255),
    revoked BOOLEAN NOT NULL DEFAULT false, -- Thêm NOT NULL cho an toàn
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
