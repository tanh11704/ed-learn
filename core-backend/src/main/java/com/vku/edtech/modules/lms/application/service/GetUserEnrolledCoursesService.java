package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.dto.EnrolledCourseResult;
import com.vku.edtech.modules.lms.application.port.in.GetUserEnrolledCoursesUseCase;
import com.vku.edtech.modules.lms.application.port.out.UserLearningQueryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GetUserEnrolledCoursesService implements GetUserEnrolledCoursesUseCase {

    private final UserLearningQueryPort userLearningQueryPort;

    @Override
    public List<EnrolledCourseResult> getEnrolledCourses(GetUserEnrolledCoursesQuery query) {
        return userLearningQueryPort.findEnrolledCoursesByUserId(query.userId());
    }
}
