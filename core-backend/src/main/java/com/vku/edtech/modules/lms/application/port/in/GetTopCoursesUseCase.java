package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.application.dto.TopCourseResult;
import java.util.List;

public interface GetTopCoursesUseCase {
    List<TopCourseResult> getTopCourses(GetTopCoursesQuery query);

    record GetTopCoursesQuery(int limit) {}
}
