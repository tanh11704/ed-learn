package com.vku.edtech.modules.exams.infrastructure.persistence.repository;

import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamAttemptAnswerJpaEntity;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExamAttemptAnswerJpaRepository
        extends JpaRepository<ExamAttemptAnswerJpaEntity, UUID> {}
