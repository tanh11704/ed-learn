package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.verifyNoMoreInteractions;
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
import org.springframework.mock.web.MockMultipartFile;

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
        verifyNoInteractions(fileStoragePort);
    }

    @Test
    @DisplayName("Upload thumbnail mới phải xóa thumbnail cũ sau khi lưu course")
    void updateCourse_withNewThumbnail_deletesOldThumbnail() {
        UUID courseId = UUID.randomUUID();
        Course course = course(courseId, "Old", "Old desc", "Math");
        course.updateDetails(null, null, null, "https://minio.phuocanh.me/edlearn/courses/old.jpg");
        MockMultipartFile thumbnailFile =
                new MockMultipartFile("thumbnailFile", "new.jpg", "image/jpeg", "image".getBytes());

        when(courseQueryPort.findByIdWithChapters(courseId)).thenReturn(Optional.of(course));
        when(fileStoragePort.uploadFile(thumbnailFile, "courses"))
                .thenReturn("https://minio.phuocanh.me/edlearn/courses/new.jpg");
        when(courseCommandPort.save(org.mockito.ArgumentMatchers.any(Course.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Course updated =
                updateCourseService.updateCourse(
                        new UpdateCourseUseCase.UpdateCourseCommand(
                                courseId, "New", "New desc", "IT", null, thumbnailFile));

        assertEquals("https://minio.phuocanh.me/edlearn/courses/new.jpg", updated.getThumbnailUrl());
        verify(fileStoragePort).uploadFile(thumbnailFile, "courses");
        verify(fileStoragePort).deleteFile("https://minio.phuocanh.me/edlearn/courses/old.jpg");
        verifyNoMoreInteractions(fileStoragePort);
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
