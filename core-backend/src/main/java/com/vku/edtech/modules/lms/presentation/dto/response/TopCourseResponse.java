package com.vku.edtech.modules.lms.presentation.dto.response;

import java.util.UUID;

public record TopCourseResponse(
        UUID courseId,
        String title,
        long totalStudents
) {}
