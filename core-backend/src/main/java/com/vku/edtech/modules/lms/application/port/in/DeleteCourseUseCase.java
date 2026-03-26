package com.vku.edtech.modules.lms.application.port.in;

import java.util.UUID;

public interface DeleteCourseUseCase {
    void deleteCourse(DeleteCourseCommand command);

    record DeleteCourseCommand(UUID courseId) {}
}
