package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Enrollment;
import java.util.UUID;

public interface EnrollCourseUseCase {
    Enrollment enrollCourse(EnrollCourseCommand command);

    record EnrollCourseCommand(UUID userId, UUID courseId) {}
}
