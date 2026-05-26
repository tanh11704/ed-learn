package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.UpdateCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateCourseService implements UpdateCourseUseCase {

    private final CourseQueryPort courseQueryPort;
    private final CourseCommandPort courseCommandPort;
    private final FileStoragePort fileStoragePort;

    //    private final CourseCachePort courseCachePort;

    @Override
    @Transactional
    @Caching(
            evict = {
                @CacheEvict(value = "courseDetail", key = "#command.courseId()"),
                @CacheEvict(value = "coursePage", allEntries = true)
            })
    public Course updateCourse(UpdateCourseCommand command) {
        Course course =
                courseQueryPort
                        .findByIdWithChapters(command.courseId())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy khóa học"));

        String thumbnailUrl = command.thumbnailUrl();
        if (command.thumbnailFile() != null && !command.thumbnailFile().isEmpty()) {
            thumbnailUrl = fileStoragePort.uploadFile(command.thumbnailFile(), "courses");
        }

        course.updateDetails(command.title(), command.description(), command.subject(), thumbnailUrl);

        Course updated = courseCommandPort.save(course);
        //        courseCachePort.deleteCourse(updated.getId());
        return updated;
    }
}
