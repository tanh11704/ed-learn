package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonContentItemJpaEntity;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface LessonContentItemJpaRepository
        extends JpaRepository<LessonContentItemJpaEntity, UUID> {

    @Query(
            "SELECT i FROM LessonContentItemJpaEntity i "
                    + "WHERE i.lesson.id = :lessonId "
                    + "AND i.isDeleted = false "
                    + "AND (:type IS NULL OR i.type = :type) "
                    + "ORDER BY i.orderIndex ASC, i.createdAt ASC, i.id ASC")
    List<LessonContentItemJpaEntity> findActiveByLessonIdAndType(
            @Param("lessonId") UUID lessonId, @Param("type") String type);

    @Query("SELECT MAX(i.orderIndex) FROM LessonContentItemJpaEntity i WHERE i.lesson.id = :lessonId AND i.isDeleted = false")
    Integer findMaxOrderIndexByLessonId(@Param("lessonId") UUID lessonId);

    Optional<LessonContentItemJpaEntity> findByIdAndIsDeletedFalse(UUID id);
}
