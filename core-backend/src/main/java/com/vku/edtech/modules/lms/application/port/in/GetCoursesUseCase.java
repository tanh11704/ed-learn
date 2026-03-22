package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface GetCoursesUseCase {
    Page<Course> getCourses(GetCoursesQuery query);

    record GetCoursesQuery(String subject, Pageable pageable) {}
}
