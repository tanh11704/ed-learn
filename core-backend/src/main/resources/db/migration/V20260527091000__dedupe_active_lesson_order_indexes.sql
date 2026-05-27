WITH ranked_lessons AS (
    SELECT
        id,
        ROW_NUMBER() OVER (
            PARTITION BY chapter_id
            ORDER BY order_index ASC, created_at ASC, id ASC
        ) AS next_order_index
    FROM lessons
    WHERE is_deleted = false
)
UPDATE lessons l
SET order_index = ranked_lessons.next_order_index
FROM ranked_lessons
WHERE l.id = ranked_lessons.id;

CREATE UNIQUE INDEX uk_active_lessons_chapter_order
    ON lessons(chapter_id, order_index)
    WHERE is_deleted = false;
