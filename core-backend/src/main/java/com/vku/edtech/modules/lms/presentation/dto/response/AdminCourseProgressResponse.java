package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record AdminCourseProgressResponse(
        UUID id,
        UUID studentId,
        String studentName,
        String email,
        UUID courseId,
        String courseTitle,
        Instant enrolledAt,
        int progressPercent,
        long completedLessons,
        long totalLessons,
        Instant lastActivity,
        String status) {}
