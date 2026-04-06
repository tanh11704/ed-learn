package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.dto.CustomPage;
import java.util.Optional;
import java.util.UUID;

public interface CourseCachePort {
    Course getCourse(UUID id);

    void saveCourse(Course course);

    void deleteCourse(UUID id);

    Optional<CustomPage<Course>> getPage(String subject, int page, int size);

    void savePage(String subject, int page, int size, CustomPage<Course> data);
}
