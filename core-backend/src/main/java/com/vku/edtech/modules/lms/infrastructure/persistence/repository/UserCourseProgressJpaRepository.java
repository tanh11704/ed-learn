package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.UserCourseProgressJpaEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserCourseProgressJpaRepository
        extends JpaRepository<UserCourseProgressJpaEntity, UUID> {
    Optional<UserCourseProgressJpaEntity> findByUserIdAndCourseId(UUID userId, UUID courseId);

    @Modifying
    @Query(
            value =
                    """
                    INSERT INTO user_courses (
                        id, user_id, course_id, progress_percent,
                        last_accessed_lesson_id, created_at, updated_at
                    )
                    VALUES (
                        gen_random_uuid(), :userId, :courseId, :progressPercent,
                        :lastAccessedLessonId, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
                    )
                    ON CONFLICT (user_id, course_id) DO UPDATE
                    SET progress_percent = EXCLUDED.progress_percent,
                        last_accessed_lesson_id = EXCLUDED.last_accessed_lesson_id,
                        updated_at = CURRENT_TIMESTAMP
                    """,
            nativeQuery = true)
    void upsertProgress(
            @Param("userId") UUID userId,
            @Param("courseId") UUID courseId,
            @Param("progressPercent") int progressPercent,
            @Param("lastAccessedLessonId") UUID lastAccessedLessonId);
}
