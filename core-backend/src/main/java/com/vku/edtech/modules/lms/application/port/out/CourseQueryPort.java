package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;
import java.util.UUID;

public interface CourseQueryPort {
    Page<Course> findCourses(String subject, Pageable pageable);
    Optional<Course> findByIdWithChapters(UUID id);
}
