package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ChapterJpaEntity;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ChapterJpaRepository extends JpaRepository<ChapterJpaEntity, UUID> {
    @Query(
            "SELECT DISTINCT c FROM ChapterJpaEntity c "
                    + "LEFT JOIN FETCH c.lessons l "
                    + "WHERE c.course.id = :courseId "
                    + "AND (:status = 'ALL' "
                    + "OR (:status = 'DELETED' AND c.isDeleted = true) "
                    + "OR (:status = 'ACTIVE' AND c.isDeleted = false)) "
                    + "ORDER BY c.orderIndex ASC, l.orderIndex ASC")
    List<ChapterJpaEntity> findAllByCourseIdWithLessons(
            @Param("courseId") UUID courseId, @Param("status") String status);

    @Query(
            "SELECT MAX(c.orderIndex) FROM ChapterJpaEntity c WHERE c.course.id = :courseId AND c.isDeleted = false")
    Integer findMaxOrderIdxByCourseId(@Param("courseId") UUID courseId);

    @Query(
            "SELECT c.id FROM ChapterJpaEntity c "
                    + "WHERE c.course.id = :courseId AND c.isDeleted = false "
                    + "ORDER BY c.orderIndex ASC, c.createdAt ASC, c.id ASC")
    List<UUID> findActiveChapterIdsByCourseId(@Param("courseId") UUID courseId);

    @Modifying
    @Query("UPDATE ChapterJpaEntity c SET c.orderIndex = :orderIndex WHERE c.id = :chapterId")
    void updateOrderIndex(@Param("chapterId") UUID chapterId, @Param("orderIndex") int orderIndex);
}
