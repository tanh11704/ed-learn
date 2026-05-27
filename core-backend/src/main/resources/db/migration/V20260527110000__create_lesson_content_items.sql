CREATE TABLE IF NOT EXISTS lesson_content_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    type VARCHAR(30) NOT NULL,
    prompt TEXT NOT NULL,
    answer TEXT NOT NULL,
    explanation TEXT,
    options_json TEXT,
    correct_option VARCHAR(10),
    order_index INTEGER NOT NULL DEFAULT 0,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_lesson_content_items_lesson_id ON lesson_content_items(lesson_id);
CREATE INDEX IF NOT EXISTS idx_lesson_content_items_type ON lesson_content_items(type);

CREATE TABLE IF NOT EXISTS lesson_content_item_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID NOT NULL REFERENCES lesson_content_items(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    repetition_count INTEGER NOT NULL DEFAULT 0,
    ease_factor DOUBLE PRECISION NOT NULL DEFAULT 2.5,
    interval_days INTEGER NOT NULL DEFAULT 1,
    next_review_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_lesson_content_item_reviews_item_user UNIQUE (item_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_lesson_content_item_reviews_user_due
    ON lesson_content_item_reviews(user_id, next_review_date);
