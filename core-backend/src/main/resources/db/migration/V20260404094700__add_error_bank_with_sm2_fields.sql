CREATE TABLE IF NOT EXISTS error_bank (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    question_content TEXT NOT NULL,
    wrong_answer TEXT,
    correct_answer TEXT,
    repetition_count INTEGER NOT NULL DEFAULT 0,
    ease_factor DOUBLE PRECISION NOT NULL DEFAULT 2.5,
    interval_days INTEGER NOT NULL DEFAULT 1,
    next_review_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_error_bank_user_id ON error_bank(user_id);
CREATE INDEX IF NOT EXISTS idx_error_bank_next_review_date ON error_bank(next_review_date);
