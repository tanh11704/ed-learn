package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.UpdateCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateCourseService implements UpdateCourseUseCase {

    private final CourseQueryPort courseQueryPort;
    private final CourseCommandPort courseCommandPort;

    @Override
    @Transactional
    public Course updateCourse(UpdateCourseCommand command) {
        Course course =
                courseQueryPort
                        .findByIdWithChapters(command.courseId())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy khóa học"));

        course.updateDetails(
                command.title(), command.description(), command.subject(), command.thumbnailUrl());

        return courseCommandPort.save(course);
    }
}
