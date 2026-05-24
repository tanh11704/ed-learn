package com.vku.edtech.modules.lms.infrastructure.persistence.projection;

import java.time.Instant;
import java.util.UUID;

public interface AdminCourseProgressProjection {
    UUID getEnrollmentId();

    UUID getStudentId();

    String getStudentName();

    String getEmail();

    UUID getCourseId();

    String getCourseTitle();

    Instant getEnrolledAt();

    Integer getProgressPercent();

    Long getCompletedLessons();

    Long getTotalLessons();

    Instant getLastActivity();

    String getStatus();
}
