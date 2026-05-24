package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record EnrolledCourseResponse(
        UUID courseId,
        String title,
        String thumbnailUrl,
        Instant enrolledDate,
        int progressPercent,
        long completedLessons,
        long totalLessons,
        UUID lastAccessedLessonId) {}
