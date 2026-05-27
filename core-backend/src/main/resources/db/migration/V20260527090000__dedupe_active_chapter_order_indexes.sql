WITH ranked_chapters AS (
    SELECT
        id,
        ROW_NUMBER() OVER (
            PARTITION BY course_id
            ORDER BY order_index ASC, created_at ASC, id ASC
        ) AS next_order_index
    FROM chapters
    WHERE is_deleted = false
)
UPDATE chapters c
SET order_index = ranked_chapters.next_order_index
FROM ranked_chapters
WHERE c.id = ranked_chapters.id;

CREATE UNIQUE INDEX uk_active_chapters_course_order
    ON chapters(course_id, order_index)
    WHERE is_deleted = false;
