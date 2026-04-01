package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetCourseMetadataUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetCourseMetadataService implements GetCourseMetadataUseCase {

    private final CourseQueryPort courseQueryPort;

    @Override
    public Course getCourseWithChapters(GetCourseMetadataQuery query) {
        return courseQueryPort
                .findByIdWithChapters(query.courseId())
                .orElseThrow(() -> new ResourceNotFoundException("Course not found"));
    }
}
