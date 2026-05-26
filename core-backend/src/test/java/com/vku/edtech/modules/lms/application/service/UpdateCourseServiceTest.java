package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.port.in.UpdateCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class UpdateCourseServiceTest {

    @Mock private CourseQueryPort courseQueryPort;
    @Mock private CourseCommandPort courseCommandPort;
    @Mock private FileStoragePort fileStoragePort;

    @InjectMocks private UpdateCourseService updateCourseService;

    @Test
    @DisplayName("Cập nhật course thành công")
    void updateCourse_success() {
        UUID courseId = UUID.randomUUID();
        Course course = course(courseId, "Old", "Old desc", "Math");
        when(courseQueryPort.findByIdWithChapters(courseId)).thenReturn(Optional.of(course));
        when(courseCommandPort.save(org.mockito.ArgumentMatchers.any(Course.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Course updated =
                updateCourseService.updateCourse(
                        new UpdateCourseUseCase.UpdateCourseCommand(
                                courseId, "New", "New desc", "IT", null, null));

        assertEquals("New", updated.getTitle());
        assertEquals("New desc", updated.getDescription());
        assertEquals("IT", updated.getSubject());
        verify(courseCommandPort).save(org.mockito.ArgumentMatchers.any(Course.class));
    }

    @Test
    @DisplayName("Cập nhật course không tồn tại phải ném ngoại lệ")
    void updateCourse_notFound() {
        UUID courseId = UUID.randomUUID();
        when(courseQueryPort.findByIdWithChapters(courseId)).thenReturn(Optional.empty());

        assertThrows(
                ResourceNotFoundException.class,
                () ->
                        updateCourseService.updateCourse(
                                new UpdateCourseUseCase.UpdateCourseCommand(
                                        courseId, "New", "New desc", "IT", null, null)));
    }

    private Course course(UUID id, String title, String description, String subject) {
        Instant now = Instant.now();
        return Course.builder()
                .id(id)
                .title(title)
                .description(description)
                .subject(subject)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }
}
