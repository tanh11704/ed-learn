CREATE TABLE exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    school_year INTEGER NOT NULL,
    duration_minutes INTEGER NOT NULL,
    total_questions INTEGER NOT NULL DEFAULT 0,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_exams_subject ON exams(subject);
CREATE INDEX idx_exams_school_year ON exams(school_year);
CREATE INDEX idx_exams_status ON exams(status);
