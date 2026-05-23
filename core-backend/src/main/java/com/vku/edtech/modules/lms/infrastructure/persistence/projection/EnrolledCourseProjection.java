package com.vku.edtech.modules.lms.infrastructure.persistence.projection;

import java.time.Instant;
import java.util.UUID;

public interface EnrolledCourseProjection {
    UUID getCourseId();

    String getTitle();

    String getThumbnailUrl();

    Instant getEnrolledDate();

    Integer getProgressPercent();

    Long getCompletedLessons();

    Long getTotalLessons();

    UUID getLastAccessedLessonId();
}
