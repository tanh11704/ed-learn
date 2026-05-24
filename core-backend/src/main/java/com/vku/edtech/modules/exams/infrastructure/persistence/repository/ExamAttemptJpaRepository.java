package com.vku.edtech.modules.exams.infrastructure.persistence.repository;

import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamAttemptJpaEntity;
import com.vku.edtech.modules.exams.infrastructure.persistence.projection.ExamAttemptSummaryProjection;
import com.vku.edtech.modules.exams.infrastructure.persistence.projection.ExamAttemptStudentProjection;
import com.vku.edtech.modules.exams.infrastructure.persistence.projection.ExamAttemptsByGradeProjection;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ExamAttemptJpaRepository extends JpaRepository<ExamAttemptJpaEntity, UUID> {

    List<ExamAttemptJpaEntity> findByUserIdOrderByStartedAtDesc(UUID userId);

    @Query(
            value =
                    """
            SELECT e.id as exam_id,
                   e.title as exam_title,
                   COUNT(a.id) as attempt_count,
                   COUNT(a.id) FILTER (WHERE a.status IN ('SUBMITTED', 'GRADED')) as submitted_count,
                   AVG(a.score) FILTER (WHERE a.status IN ('SUBMITTED', 'GRADED')) as average_score,
                   MAX(a.score) FILTER (WHERE a.status IN ('SUBMITTED', 'GRADED')) as highest_score,
                   MIN(a.score) FILTER (WHERE a.status IN ('SUBMITTED', 'GRADED')) as lowest_score
            FROM exams e
            LEFT JOIN exam_attempts a ON a.exam_id = e.id
            WHERE e.id = :examId
            GROUP BY e.id, e.title
            """,
            nativeQuery = true)
    ExamAttemptSummaryProjection getSummaryByExamId(@Param("examId") UUID examId);

    @Query(
            value =
                    """
            SELECT a.grade_level as grade_level,
                   COUNT(a.id) as attempt_count,
                   COUNT(a.id) FILTER (WHERE a.status IN ('SUBMITTED', 'GRADED')) as submitted_count,
                   AVG(a.score) FILTER (WHERE a.status IN ('SUBMITTED', 'GRADED')) as average_score
            FROM exam_attempts a
            WHERE a.exam_id = :examId
            GROUP BY a.grade_level
            ORDER BY a.grade_level ASC
            """,
            nativeQuery = true)
    List<ExamAttemptsByGradeProjection> getAttemptsByGrade(@Param("examId") UUID examId);

    @Query(
            value =
                    """
            SELECT a.grade_level as grade_level,
                   COUNT(a.id) as attempt_count,
                   COUNT(a.id) FILTER (WHERE a.status IN ('SUBMITTED', 'GRADED')) as submitted_count,
                   AVG(a.score) FILTER (WHERE a.status IN ('SUBMITTED', 'GRADED')) as average_score
            FROM exam_attempts a
            GROUP BY a.grade_level
            ORDER BY a.grade_level ASC
            """,
            nativeQuery = true)
    List<ExamAttemptsByGradeProjection> getAttemptsByGrade();

    @Query(
            value =
                    """
            SELECT a.id as attempt_id,
                   a.exam_id as exam_id,
                   u.id as student_id,
                   u.full_name as student_name,
                   u.email as email,
                   a.grade_level as grade_level,
                   a.class_name as class_name,
                   a.status as status,
                   a.started_at as started_at,
                   a.submitted_at as submitted_at,
                   a.duration_seconds as duration_seconds,
                   a.score as score,
                   a.max_score as max_score
            FROM exam_attempts a
            JOIN users u ON u.id = a.user_id
            WHERE a.exam_id = :examId
            ORDER BY COALESCE(a.submitted_at, a.started_at) DESC
            """,
            nativeQuery = true)
    List<ExamAttemptStudentProjection> findStudentAttemptsByExamId(
            @Param("examId") UUID examId);
}
