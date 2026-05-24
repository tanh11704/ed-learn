package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.EnrollmentJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.projection.AdminCourseProgressProjection;
import com.vku.edtech.modules.lms.infrastructure.persistence.projection.EnrolledCourseProjection;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

public interface UserLearningJpaRepository extends Repository<EnrollmentJpaEntity, UUID> {

    @Query(
            value =
                    """
            SELECT c.id as course_id,
                   c.title as title,
                   c.thumbnail_url as thumbnail_url,
                   e.created_at as enrolled_date,
                   CAST(CASE
                       WHEN COALESCE(total_lessons.total_count, 0) = 0 THEN 0
                       ELSE LEAST(
                           100,
                           FLOOR((COALESCE(completed_lessons.completed_count, 0) * 100.0) / total_lessons.total_count)
                       )
                   END AS integer) as progress_percent,
                   COALESCE(completed_lessons.completed_count, 0) as completed_lessons,
                   COALESCE(total_lessons.total_count, 0) as total_lessons,
                   uc.last_accessed_lesson_id as last_accessed_lesson_id
            FROM courses c
            JOIN enrollments e ON c.id = e.course_id
            LEFT JOIN user_courses uc ON uc.user_id = e.user_id AND uc.course_id = c.id
            LEFT JOIN (
                SELECT ch.course_id, COUNT(l.id) as total_count
                FROM lessons l
                JOIN chapters ch ON ch.id = l.chapter_id
                WHERE l.is_deleted = false AND ch.is_deleted = false
                GROUP BY ch.course_id
            ) total_lessons ON total_lessons.course_id = c.id
            LEFT JOIN (
                SELECT ch.course_id, upl.user_id, COUNT(upl.id) as completed_count
                FROM user_progress_lessons upl
                JOIN lessons l ON l.id = upl.lesson_id
                JOIN chapters ch ON ch.id = l.chapter_id
                WHERE upl.status = 'COMPLETED'
                  AND l.is_deleted = false
                  AND ch.is_deleted = false
                GROUP BY ch.course_id, upl.user_id
            ) completed_lessons ON completed_lessons.course_id = c.id AND completed_lessons.user_id = e.user_id
            WHERE e.user_id = :userId AND c.status = 'ACTIVE'
            ORDER BY e.created_at DESC
            """,
            nativeQuery = true)
    List<EnrolledCourseProjection> findEnrolledCoursesByUserId(@Param("userId") UUID userId);

    @Query(
            value =
                    """
            SELECT e.id as enrollment_id,
                   u.id as student_id,
                   u.full_name as student_name,
                   u.email as email,
                   c.id as course_id,
                   c.title as course_title,
                   e.created_at as enrolled_at,
                   CAST(CASE
                       WHEN COALESCE(total_lessons.total_count, 0) = 0 THEN 0
                       ELSE LEAST(
                           100,
                           FLOOR((COALESCE(completed_lessons.completed_count, 0) * 100.0) / total_lessons.total_count)
                       )
                   END AS integer) as progress_percent,
                   COALESCE(completed_lessons.completed_count, 0) as completed_lessons,
                   COALESCE(total_lessons.total_count, 0) as total_lessons,
                   COALESCE(completed_lessons.last_completed_at, uc.updated_at, e.updated_at, e.created_at) as last_activity,
                   CASE
                       WHEN COALESCE(total_lessons.total_count, 0) > 0
                            AND COALESCE(completed_lessons.completed_count, 0) >= total_lessons.total_count
                           THEN 'COMPLETED'
                       WHEN COALESCE(completed_lessons.last_completed_at, uc.updated_at, e.updated_at, e.created_at)
                            < (CURRENT_TIMESTAMP - INTERVAL '14 days')
                           THEN 'INACTIVE'
                       ELSE 'LEARNING'
                   END as status
            FROM enrollments e
            JOIN users u ON u.id = e.user_id
            JOIN courses c ON c.id = e.course_id
            LEFT JOIN user_courses uc ON uc.user_id = e.user_id AND uc.course_id = c.id
            LEFT JOIN (
                SELECT ch.course_id, COUNT(l.id) as total_count
                FROM lessons l
                JOIN chapters ch ON ch.id = l.chapter_id
                WHERE l.is_deleted = false AND ch.is_deleted = false
                GROUP BY ch.course_id
            ) total_lessons ON total_lessons.course_id = c.id
            LEFT JOIN (
                SELECT ch.course_id,
                       upl.user_id,
                       COUNT(upl.id) as completed_count,
                       MAX(COALESCE(upl.completed_at, upl.updated_at, upl.created_at)) as last_completed_at
                FROM user_progress_lessons upl
                JOIN lessons l ON l.id = upl.lesson_id
                JOIN chapters ch ON ch.id = l.chapter_id
                WHERE upl.status = 'COMPLETED'
                  AND l.is_deleted = false
                  AND ch.is_deleted = false
                GROUP BY ch.course_id, upl.user_id
            ) completed_lessons ON completed_lessons.course_id = c.id AND completed_lessons.user_id = e.user_id
            WHERE e.status = 'ACTIVE'
              AND c.status = 'ACTIVE'
              AND e.course_id = :courseId
            ORDER BY last_activity DESC, e.created_at DESC
            """,
            nativeQuery = true)
    List<AdminCourseProgressProjection> findCourseProgressByCourseId(
            @Param("courseId") UUID courseId);
}
