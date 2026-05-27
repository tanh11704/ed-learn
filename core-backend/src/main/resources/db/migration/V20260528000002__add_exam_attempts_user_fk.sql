DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_exam_attempts_user_id'
          AND conrelid = 'exam_attempts'::regclass
    ) THEN
        ALTER TABLE exam_attempts
            ADD CONSTRAINT fk_exam_attempts_user_id
            FOREIGN KEY (user_id)
            REFERENCES users(id)
            ON DELETE RESTRICT;
    END IF;
END $$;
