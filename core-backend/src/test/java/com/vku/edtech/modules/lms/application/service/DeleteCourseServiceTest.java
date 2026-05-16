package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.port.in.DeleteCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
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
class DeleteCourseServiceTest {

    @Mock private CourseQueryPort courseQueryPort;
    @Mock private CourseCommandPort courseCommandPort;

    @InjectMocks private DeleteCourseService deleteCourseService;

    @Test
    @DisplayName("Xóa course sẽ đánh dấu deleted")
    void deleteCourse_success() {
        UUID courseId = UUID.randomUUID();
        Course course = course(courseId);
        when(courseQueryPort.findByIdWithChapters(courseId)).thenReturn(Optional.of(course));

        deleteCourseService.deleteCourse(new DeleteCourseUseCase.DeleteCourseCommand(courseId));

        verify(courseCommandPort).save(org.mockito.ArgumentMatchers.any(Course.class));
    }

    @Test
    @DisplayName("Xóa course không tồn tại phải ném ngoại lệ")
    void deleteCourse_notFound() {
        UUID courseId = UUID.randomUUID();
        when(courseQueryPort.findByIdWithChapters(courseId)).thenReturn(Optional.empty());

        assertThrows(
                ResourceNotFoundException.class,
                () -> deleteCourseService.deleteCourse(new DeleteCourseUseCase.DeleteCourseCommand(courseId)));
    }

    private Course course(UUID id) {
        Instant now = Instant.now();
        return Course.builder().id(id).title("t").description("d").subject("s").createdAt(now).updatedAt(now).build();
    }
}
