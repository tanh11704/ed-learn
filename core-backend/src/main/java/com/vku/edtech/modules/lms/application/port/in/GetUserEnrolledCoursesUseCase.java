package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.application.dto.EnrolledCourseResult;
import java.util.List;
import java.util.UUID;

public interface GetUserEnrolledCoursesUseCase {
    List<EnrolledCourseResult> getEnrolledCourses(GetUserEnrolledCoursesQuery query);

    record GetUserEnrolledCoursesQuery(UUID userId) {}
}
