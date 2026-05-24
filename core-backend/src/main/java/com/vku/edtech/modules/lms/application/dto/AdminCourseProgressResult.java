package com.vku.edtech.modules.lms.application.dto;

import java.time.Instant;
import java.util.UUID;

public record AdminCourseProgressResult(
        UUID enrollmentId,
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
