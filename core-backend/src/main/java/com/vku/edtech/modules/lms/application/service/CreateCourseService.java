package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.CreateCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateCourseService implements CreateCourseUseCase {

    private final CourseCommandPort courseCommandPort;
    private final FileStoragePort fileStoragePort;

    @Override
    @Transactional
    @CacheEvict(value = "coursePage", allEntries = true)
    public Course createCourse(CreateCourseCommand command) {
        String thumbnailUrl = command.thumbnailUrl();
        if (command.thumbnailFile() != null && !command.thumbnailFile().isEmpty()) {
            thumbnailUrl = fileStoragePort.uploadFile(command.thumbnailFile(), "courses");
        }

        Course newCourse =
                Course.createNew(command.title(), command.description(), command.subject());
        newCourse.updateDetails(null, null, null, thumbnailUrl);

        return courseCommandPort.save(newCourse);
    }
}
