package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Course;

public interface CourseCommandPort {
    Course save(Course course);
}
