package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.port.in.DeleteLessonUseCase;
import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Lesson;
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
class DeleteLessonServiceTest {

    @Mock private LessonQueryPort lessonQueryPort;
    @Mock private LessonCommandPort lessonCommandPort;

    @InjectMocks private DeleteLessonService deleteLessonService;

    @Test
    @DisplayName("Xóa lesson sẽ mark deleted và save")
    void deleteLesson_success() {
        UUID lessonId = UUID.randomUUID();
        when(lessonQueryPort.findByIdAndNotDeleted(lessonId)).thenReturn(Optional.of(lesson(lessonId)));

        deleteLessonService.delete(new DeleteLessonUseCase.DeleteLessonCommand(lessonId));

        verify(lessonCommandPort).save(org.mockito.ArgumentMatchers.any(Lesson.class));
    }

    @Test
    @DisplayName("Xóa lesson không tồn tại phải ném ngoại lệ")
    void deleteLesson_notFound() {
        UUID lessonId = UUID.randomUUID();
        when(lessonQueryPort.findByIdAndNotDeleted(lessonId)).thenReturn(Optional.empty());

        assertThrows(
                ResourceNotFoundException.class,
                () -> deleteLessonService.delete(new DeleteLessonUseCase.DeleteLessonCommand(lessonId)));
    }

    private Lesson lesson(UUID id) {
        Instant now = Instant.now();
        return Lesson.builder().id(id).title("t").chapterId(UUID.randomUUID()).orderIndex(1).isDeleted(false).createdAt(now).updatedAt(now).build();
    }
}
