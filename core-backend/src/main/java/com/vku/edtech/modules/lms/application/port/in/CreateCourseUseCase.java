package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Course;

public interface CreateCourseUseCase {
    Course createCourse(CreateCourseCommand command);

    record CreateCourseCommand(String title, String description, String subject) {}
}
