package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.UserProgressLessonJpaEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
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
}
