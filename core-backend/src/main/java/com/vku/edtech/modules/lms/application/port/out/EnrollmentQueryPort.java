package com.vku.edtech.modules.lms.application.port.out;

import java.util.UUID;

public interface EnrollmentQueryPort {
    boolean existsByUserIdAndCourseId(UUID userId, UUID courseId);
}
