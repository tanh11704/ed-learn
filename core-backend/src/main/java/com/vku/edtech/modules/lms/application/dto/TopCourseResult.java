package com.vku.edtech.modules.lms.application.dto;

import java.util.UUID;

public record TopCourseResult(
        UUID courseId,
        String title,
        long totalStudents
) {
}
