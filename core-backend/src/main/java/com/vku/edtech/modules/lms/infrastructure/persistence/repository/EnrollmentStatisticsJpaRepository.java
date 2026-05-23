package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.EnrollmentJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.projection.MonthlyEnrollmentProjection;
import com.vku.edtech.modules.lms.infrastructure.persistence.projection.TopCourseProjection;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

public interface EnrollmentStatisticsJpaRepository
        extends Repository<EnrollmentJpaEntity, UUID> {

    @Query(
            value =
                    """
            SELECT c.id as course_id, c.title as title, COUNT(e.id) as total_students
            FROM courses c
            JOIN enrollments e ON c.id = e.course_id
            GROUP BY c.id, c.title
            ORDER BY total_students DESC
            LIMIT :limit
            """,
            nativeQuery = true)
    List<TopCourseProjection> findTopCourses(@Param("limit") int limit);

    @Query(value = "SELECT COUNT(DISTINCT user_id) FROM enrollments", nativeQuery = true)
    long countTotalStudents();

    @Query(value = "SELECT COUNT(id) FROM courses WHERE status = 'ACTIVE'", nativeQuery = true)
    long countTotalCourses();

    @Query(
            value =
                    """
            SELECT COUNT(id)
            FROM enrollments
            WHERE created_at >= :startDate AND created_at < :endDate
            """,
            nativeQuery = true)
    long countCurrentMonthEnrollments(
            @Param("startDate") Instant startDate, @Param("endDate") Instant endDate);

    @Query(
            value =
                    """
            SELECT COALESCE(SUM(price), 0)
            FROM enrollments
            WHERE created_at >= :startDate AND created_at < :endDate
            """,
            nativeQuery = true)
    Long sumCurrentMonthRevenue(
            @Param("startDate") Instant startDate, @Param("endDate") Instant endDate);

    @Query(
            value =
                    """
            SELECT EXTRACT(MONTH FROM created_at) as month,
                   EXTRACT(YEAR FROM created_at) as year,
                   COUNT(id) as enrollments
            FROM enrollments
            WHERE created_at >= :startDate AND created_at < :endDate
            GROUP BY EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at)
            ORDER BY month ASC
            """,
            nativeQuery = true)
    List<MonthlyEnrollmentProjection> countMonthlyEnrollments(
            @Param("startDate") Instant startDate, @Param("endDate") Instant endDate);
}
