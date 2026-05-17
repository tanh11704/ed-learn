package com.vku.edtech.modules.exams.infrastructure.persistence.repository;

import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamJpaEntity;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ExamJpaRepository extends JpaRepository<ExamJpaEntity, UUID> {}
