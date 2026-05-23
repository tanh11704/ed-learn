package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ErrorBankJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.projection.ErrorBankStudentStatisticProjection;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ErrorBankJpaRepository extends JpaRepository<ErrorBankJpaEntity, UUID> {
    List<ErrorBankJpaEntity> findByUserIdAndNextReviewDateLessThanEqualOrderByNextReviewDateAsc(
            UUID userId, Instant now, Pageable pageable);

    Optional<ErrorBankJpaEntity> findByIdAndUserId(UUID id, UUID userId);

    @Query(
            value =
                    """
            SELECT u.id as student_id,
                   u.full_name as student_name,
                   u.email as email,
                   latest_attempt.grade_level as grade_level,
                   latest_attempt.class_name as class_name,
                   COUNT(e.id) as total_errors,
                   COUNT(e.id) FILTER (WHERE e.next_review_date <= :now) as due_errors,
                   COUNT(e.id) FILTER (WHERE e.repetition_count > 0) as reviewed_errors,
                   COUNT(e.id) FILTER (WHERE e.repetition_count >= 3) as mastered_errors,
                   AVG(e.ease_factor) as average_ease_factor,
                   AVG(e.interval_days) as average_interval_days,
                   MIN(e.next_review_date) as next_review_date,
                   MAX(COALESCE(e.updated_at, e.created_at)) as last_updated_at
            FROM error_bank e
            JOIN users u ON u.id = e.user_id
            LEFT JOIN LATERAL (
                SELECT a.grade_level, a.class_name
                FROM exam_attempts a
                WHERE a.user_id = u.id
                ORDER BY COALESCE(a.submitted_at, a.started_at) DESC
                LIMIT 1
            ) latest_attempt ON true
            GROUP BY u.id, u.full_name, u.email, latest_attempt.grade_level, latest_attempt.class_name
            ORDER BY due_errors DESC, total_errors DESC, last_updated_at DESC
            """,
            nativeQuery = true)
    List<ErrorBankStudentStatisticProjection> getStudentStatistics(@Param("now") Instant now);
}
