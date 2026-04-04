CREATE TABLE user_progress_lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    lesson_id UUID NOT NULL REFERENCES lessons(id),
    status VARCHAR(20) NOT NULL,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_user_progress_lessons_user_lesson UNIQUE (user_id, lesson_id)
);

CREATE INDEX idx_user_progress_lessons_user_id ON user_progress_lessons(user_id);
CREATE INDEX idx_user_progress_lessons_lesson_id ON user_progress_lessons(lesson_id);
CREATE INDEX idx_user_progress_lessons_status ON user_progress_lessons(status);

CREATE TABLE user_courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    course_id UUID NOT NULL REFERENCES courses(id),
    progress_percent INTEGER NOT NULL DEFAULT 0,
    last_accessed_lesson_id UUID REFERENCES lessons(id),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_user_courses_user_course UNIQUE (user_id, course_id)
);

CREATE INDEX idx_user_courses_user_id ON user_courses(user_id);
CREATE INDEX idx_user_courses_course_id ON user_courses(course_id);
