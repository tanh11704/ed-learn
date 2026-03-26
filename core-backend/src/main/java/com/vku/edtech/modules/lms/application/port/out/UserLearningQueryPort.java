package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.application.dto.EnrolledCourseResult;
import java.util.List;
import java.util.UUID;

public interface UserLearningQueryPort {
    List<EnrolledCourseResult> findEnrolledCoursesByUserId(UUID userId);
}
