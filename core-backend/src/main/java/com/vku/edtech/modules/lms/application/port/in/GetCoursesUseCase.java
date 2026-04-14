package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.dto.CustomPage;
import org.springframework.data.domain.Pageable;

public interface GetCoursesUseCase {
    CustomPage<Course> getCourses(GetCoursesQuery query);

    record GetCoursesQuery(String subject, Pageable pageable) {}
}
