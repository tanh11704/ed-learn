package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetCourseMetadataUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCachePort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetCourseMetadataService implements GetCourseMetadataUseCase {

    private final CourseQueryPort courseQueryPort;
    private final CourseCachePort courseCachePort;

    @Override
    public Course getCourseWithChapters(GetCourseMetadataQuery query) {
        Course cached = courseCachePort.getCourse(query.courseId());
        if (cached != null) {
            return cached;
        }

        Course course =
                courseQueryPort
                        .findByIdWithChapters(query.courseId())
                        .orElseThrow(() -> new ResourceNotFoundException("Course not found"));

        courseCachePort.saveCourse(course);
        return course;
    }
}
