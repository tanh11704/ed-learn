package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Enrollment;
import java.util.UUID;

public interface EnrollmentCommandPort {
    Enrollment save(Enrollment enrollment);

    boolean existsByUserIdAndCourseId(UUID userId, UUID courseId);
}
