package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.exception.LmsBadRequestException;
import com.vku.edtech.modules.lms.application.port.in.UpdateLessonUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
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
class UpdateLessonServiceTest {

    @Mock private LessonCommandPort lessonCommandPort;
    @Mock private LessonQueryPort lessonQueryPort;
    @Mock private ChapterQueryPort chapterQueryPort;

    @InjectMocks private UpdateLessonService updateLessonService;

    @Test
    @DisplayName("Update lesson thành công")
    void updateLesson_success() {
        UUID lessonId = UUID.randomUUID();
        UUID chapterId = UUID.randomUUID();
        Lesson lesson = lesson(lessonId, UUID.randomUUID(), "Old", 1, false);

        when(lessonQueryPort.findByIdAndNotDeleted(lessonId)).thenReturn(Optional.of(lesson));
        when(chapterQueryPort.findById(chapterId)).thenReturn(Optional.of(chapter(chapterId, false)));
        when(lessonQueryPort.findMaxOrderIndexByChapterId(chapterId)).thenReturn(Optional.of(1));
        when(lessonCommandPort.save(org.mockito.ArgumentMatchers.any(Lesson.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Lesson updated =
                updateLessonService.update(
                        new UpdateLessonUseCase.UpdateLessonCommand(
                                lessonId, chapterId, "New", null, true));

        assertEquals("New", updated.getTitle());
        assertEquals(2, updated.getOrderIndex());
        verify(lessonCommandPort).save(org.mockito.ArgumentMatchers.any(Lesson.class));
    }

    @Test
    @DisplayName("Update lesson rejects direct orderIndex changes")
    void updateLesson_rejectsDirectOrderIndexChange() {
        UUID lessonId = UUID.randomUUID();
        UUID chapterId = UUID.randomUUID();
        Lesson lesson = lesson(lessonId, chapterId, "Old", 3, false);

        when(lessonQueryPort.findByIdAndNotDeleted(lessonId)).thenReturn(Optional.of(lesson));

        assertThrows(
                LmsBadRequestException.class,
                () ->
                        updateLessonService.update(
                                new UpdateLessonUseCase.UpdateLessonCommand(
                                        lessonId, chapterId, "New", 1, true)));
    }

    @Test
    @DisplayName("Update lesson không tồn tại phải ném ngoại lệ")
    void updateLesson_notFound() {
        UUID lessonId = UUID.randomUUID();
        when(lessonQueryPort.findByIdAndNotDeleted(lessonId)).thenReturn(Optional.empty());

        assertThrows(
                ResourceNotFoundException.class,
                () ->
                        updateLessonService.update(
                                new UpdateLessonUseCase.UpdateLessonCommand(
                                        lessonId, null, "New", null, false)));
    }

    private Chapter chapter(UUID id, boolean deleted) {
        Instant now = Instant.now();
        return Chapter.builder()
                .id(id)
                .courseId(UUID.randomUUID())
                .title("t")
                .orderIndex(1)
                .isDeleted(deleted)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }

    private Lesson lesson(UUID id, UUID chapterId, String title, int orderIndex, boolean preview) {
        Instant now = Instant.now();
        return Lesson.builder()
                .id(id)
                .chapterId(chapterId)
                .title(title)
                .orderIndex(orderIndex)
                .isPreview(preview)
                .isDeleted(false)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }
}
