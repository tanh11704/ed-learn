package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonJpaEntity;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface LessonJpaRepository extends JpaRepository<LessonJpaEntity, UUID> {

    @Query("SELECT l FROM LessonJpaEntity l WHERE l.id = :lessonId AND l.isDeleted = false")
    Optional<LessonJpaEntity> findByIdAndNotDeleted(@Param("lessonId") UUID lessonId);

    @Query(
            "SELECT MAX(l.orderIndex) FROM LessonJpaEntity l "
                    + "WHERE l.chapter.id = :chapterId AND l.isDeleted = false")
    Optional<Integer> findMaxOrderIndexByChapterId(@Param("chapterId") UUID chapterId);

    @Query(
            "SELECT c.course.id FROM LessonJpaEntity l "
                    + "JOIN l.chapter c "
                    + "WHERE l.id = :lessonId AND l.isDeleted = false")
    Optional<UUID> findCourseIdByLessonId(@Param("lessonId") UUID lessonId);

    @Query(
            "SELECT COUNT(l.id) FROM LessonJpaEntity l "
                    + "JOIN l.chapter c "
                    + "WHERE c.course.id = :courseId AND l.isDeleted = false AND c.isDeleted = false")
    long countLessonsByCourseId(@Param("courseId") UUID courseId);

    @Query(
            "SELECT l.id FROM LessonJpaEntity l "
                    + "WHERE l.chapter.id = :chapterId AND l.isDeleted = false "
                    + "ORDER BY l.orderIndex ASC, l.createdAt ASC, l.id ASC")
    List<UUID> findActiveLessonIdsByChapterId(@Param("chapterId") UUID chapterId);

    @Modifying
    @Query("UPDATE LessonJpaEntity l SET l.orderIndex = :orderIndex WHERE l.id = :lessonId")
    void updateOrderIndex(@Param("lessonId") UUID lessonId, @Param("orderIndex") int orderIndex);
}
