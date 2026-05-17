package com.vku.edtech.modules.exams.infrastructure.persistence.repository;

import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamQuestionJpaEntity;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ExamQuestionJpaRepository extends JpaRepository<ExamQuestionJpaEntity, UUID> {
    @Query(
            "SELECT DISTINCT q FROM ExamQuestionJpaEntity q "
                    + "LEFT JOIN FETCH q.options o "
                    + "WHERE q.id = :questionId")
    Optional<ExamQuestionJpaEntity> findByIdWithOptions(@Param("questionId") UUID questionId);

    @Query(
            "SELECT DISTINCT q FROM ExamQuestionJpaEntity q "
                    + "LEFT JOIN FETCH q.options o "
                    + "WHERE q.exam.id = :examId "
                    + "ORDER BY q.orderIndex ASC, o.orderIndex ASC")
    List<ExamQuestionJpaEntity> findAllByExamIdWithOptions(@Param("examId") UUID examId);
}
