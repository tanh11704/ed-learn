package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetCourseMetadataUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetCourseMetadataService implements GetCourseMetadataUseCase {

    private final CourseQueryPort courseQueryPort;

    // private final CourseCachePort courseCachePort;

    @Override
    @Cacheable(value = "courseDetail", key = "#query.courseId()", sync = true)
    public Course getCourseWithChapters(GetCourseMetadataQuery query) {
        // Course cached = courseCachePort.getCourse(query.courseId());
        // if (cached != null) {
        //     return cached;
        // }

        // courseCachePort.saveCourse(course);
        return courseQueryPort
                .findByIdWithChapters(query.courseId())
                .orElseThrow(() -> new ResourceNotFoundException("Course not found"));
    }
}
