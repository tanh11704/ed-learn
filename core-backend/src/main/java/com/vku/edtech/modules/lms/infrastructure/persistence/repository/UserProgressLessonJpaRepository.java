package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.UserProgressLessonJpaEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserProgressLessonJpaRepository
        extends JpaRepository<UserProgressLessonJpaEntity, UUID> {

    Optional<UserProgressLessonJpaEntity> findByUserIdAndLessonId(UUID userId, UUID lessonId);

    @Query(
            "SELECT COUNT(u.id) FROM UserProgressLessonJpaEntity u "
                    + "JOIN LessonJpaEntity l ON l.id = u.lessonId "
                    + "JOIN l.chapter c "
                    + "WHERE u.userId = :userId "
                    + "AND c.course.id = :courseId "
                    + "AND u.status = com.vku.edtech.modules.lms.domain.model.LessonProgressStatus.COMPLETED "
                    + "AND l.isDeleted = false AND c.isDeleted = false")
    long countCompletedByUserIdAndCourseId(
            @Param("userId") UUID userId, @Param("courseId") UUID courseId);

    @Modifying
    @Query(
            value =
                    """
                    INSERT INTO user_progress_lessons (
                        id, user_id, lesson_id, status, completed_at, created_at, updated_at
                    )
                    VALUES (
                        gen_random_uuid(), :userId, :lessonId, 'COMPLETED',
                        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
                    )
                    ON CONFLICT (user_id, lesson_id) DO UPDATE
                    SET status = 'COMPLETED',
                        completed_at = COALESCE(user_progress_lessons.completed_at, EXCLUDED.completed_at),
                        updated_at = CURRENT_TIMESTAMP
                    WHERE user_progress_lessons.status <> 'COMPLETED'
                    """,
            nativeQuery = true)
    int markCompleted(@Param("userId") UUID userId, @Param("lessonId") UUID lessonId);
}
