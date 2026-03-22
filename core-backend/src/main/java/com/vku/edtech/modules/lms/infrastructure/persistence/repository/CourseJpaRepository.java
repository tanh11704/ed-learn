package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.CourseJpaEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface CourseJpaRepository extends JpaRepository<CourseJpaEntity, UUID> {

    @Query("SELECT c FROM CourseJpaEntity c WHERE :subject IS NULL OR c.subject = :subject")
    Page<CourseJpaEntity> findBySubjectOrAll(String subject, Pageable pageable);

    @Query("SELECT c FROM CourseJpaEntity c LEFT JOIN FETCH c.chapters ch LEFT JOIN FETCH ch.lessons WHERE c.id = :id")
    Optional<CourseJpaEntity> findByIdWithChapters(@Param("id") UUID id);
}
