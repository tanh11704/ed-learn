package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.CreateCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateCourseService implements CreateCourseUseCase {

    private final CourseCommandPort courseCommandPort;

    @Override
    @Transactional
    public Course createCourse(CreateCourseCommand command) {
        Course newCourse = Course.createNew(
                command.title(),
                command.description(),
                command.subject()
        );

        return courseCommandPort.save(newCourse);
    }
}
