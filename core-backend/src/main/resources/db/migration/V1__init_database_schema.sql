-- Kích hoạt extension để tự động sinh UUID trong PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. BẢNG USERS
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. BẢNG COURSES
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. BẢNG MATERIALS (PDF)
CREATE TABLE materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    course_id UUID NOT NULL REFERENCES courses (id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. BẢNG QUIZZES & QUESTIONS
CREATE TABLE quizzes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    material_id UUID NOT NULL REFERENCES materials (id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    total_questions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    quiz_id UUID NOT NULL REFERENCES quizzes (id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,
    correct_answer CHAR(1) NOT NULL,
    explanation TEXT
);

CREATE TABLE quiz_attempts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    quiz_id UUID NOT NULL REFERENCES quizzes (id) ON DELETE CASCADE,
    score FLOAT NOT NULL,
    total_correct INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. BẢNG FLASHCARDS & SPACED REPETITION (UPGRADE)
CREATE TABLE flashcards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    material_id UUID NOT NULL REFERENCES materials (id) ON DELETE CASCADE,
    front_text TEXT NOT NULL,
    back_text TEXT NOT NULL
);

CREATE TABLE flashcard_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    flashcard_id UUID NOT NULL REFERENCES flashcards (id) ON DELETE CASCADE,
    next_review_date DATE NOT NULL,
    interval_days INT NOT NULL DEFAULT 1,
    ease_factor FLOAT NOT NULL DEFAULT 2.5,
    review_count INT NOT NULL DEFAULT 0,
    last_reviewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);