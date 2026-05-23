CREATE TABLE exam_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id UUID NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    grade_level INTEGER NOT NULL,
    class_name VARCHAR(100),
    status VARCHAR(30) NOT NULL DEFAULT 'IN_PROGRESS',
    started_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    submitted_at TIMESTAMPTZ,
    duration_seconds INTEGER,
    score DOUBLE PRECISION,
    max_score DOUBLE PRECISION,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_exam_attempts_exam_id ON exam_attempts(exam_id);
CREATE INDEX idx_exam_attempts_user_id ON exam_attempts(user_id);
CREATE INDEX idx_exam_attempts_grade_level ON exam_attempts(grade_level);
CREATE INDEX idx_exam_attempts_status ON exam_attempts(status);
CREATE INDEX idx_exam_attempts_started_at ON exam_attempts(started_at);

CREATE TABLE exam_attempt_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id UUID NOT NULL REFERENCES exam_attempts(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES exam_questions(id) ON DELETE CASCADE,
    selected_option_id UUID REFERENCES exam_question_options(id),
    answer_text TEXT,
    correct BOOLEAN,
    score DOUBLE PRECISION,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_exam_attempt_answers_attempt_question UNIQUE (attempt_id, question_id)
);

CREATE INDEX idx_exam_attempt_answers_attempt_id ON exam_attempt_answers(attempt_id);
CREATE INDEX idx_exam_attempt_answers_question_id ON exam_attempt_answers(question_id);
