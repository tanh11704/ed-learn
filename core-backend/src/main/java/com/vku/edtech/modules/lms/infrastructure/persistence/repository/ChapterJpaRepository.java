package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ChapterJpaEntity;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ChapterJpaRepository extends JpaRepository<ChapterJpaEntity, UUID> {
    @Query("SELECT c FROM ChapterJpaEntity c " +
            "LEFT JOIN FETCH c.lessons l " +
            "WHERE c.course.id = :courseId " +
            "AND c.isDeleted = false " +
            "ORDER BY c.orderIndex ASC, l.orderIndex ASC")
    List<ChapterJpaEntity> findAllByCourseIdWithLessons(@Param("courseId") UUID courseId);

    @Query("SELECT MAX(c.orderIndex) FROM ChapterJpaEntity c WHERE c.course.id = :courseId AND c.isDeleted = false")
    Integer findMaxOrderIdxByCourseId(@Param("courseId") UUID courseId);
}
