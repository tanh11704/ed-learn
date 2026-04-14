package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.DeleteCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteCourseService implements DeleteCourseUseCase {

    private final CourseQueryPort courseQueryPort;
    private final CourseCommandPort courseCommandPort;

    //    private final CourseCachePort courseCachePort;

    @Override
    @Transactional
    @CacheEvict(value = "courseDetail", key = "#command.courseId()")
    public void deleteCourse(DeleteCourseCommand command) {
        Course course =
                courseQueryPort
                        .findByIdWithChapters(command.courseId())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy khóa học"));

        course.markAsDeleted();
        courseCommandPort.save(course);
        //        courseCachePort.deleteCourse(command.courseId());
    }
}
