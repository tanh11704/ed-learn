package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Course;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public interface UpdateCourseUseCase {
    Course updateCourse(UpdateCourseCommand command);

    record UpdateCourseCommand(
            UUID courseId,
            String title,
            String description,
            String subject,
            String thumbnailUrl,
            MultipartFile thumbnailFile) {}
}
