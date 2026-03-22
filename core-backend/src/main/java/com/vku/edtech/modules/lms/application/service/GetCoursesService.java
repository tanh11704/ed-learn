package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetCoursesUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetCoursesService implements GetCoursesUseCase {

    private final CourseQueryPort courseQueryPort;

    @Override
    public Page<Course> getCourses(GetCoursesQuery query) {
        return courseQueryPort.findCourses(query.subject(), query.pageable());
    }
}
