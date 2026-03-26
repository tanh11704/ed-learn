package com.vku.edtech.modules.lms.application.dto;

import java.time.Instant;
import java.util.UUID;

public record EnrolledCourseResult(
        UUID courseId,
        String title,
        String thumbnailUrl,
        Instant enrolledDate
) {}
