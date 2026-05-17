package com.vku.edtech.modules.exams.infrastructure.persistence.repository;

import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamQuestionOptionJpaEntity;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ExamQuestionOptionJpaRepository extends JpaRepository<ExamQuestionOptionJpaEntity, UUID> {
    List<ExamQuestionOptionJpaEntity> findAllByQuestionIdOrderByOrderIndexAsc(UUID questionId);
}
