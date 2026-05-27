package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.port.in.CreateLessonUseCase;
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
class CreateLessonServiceTest {

    @Mock private LessonCommandPort lessonCommandPort;
    @Mock private LessonQueryPort lessonQueryPort;
    @Mock private ChapterQueryPort chapterQueryPort;

    @InjectMocks private CreateLessonService createLessonService;

    @Test
    @DisplayName("Tạo lesson tự tăng orderIndex khi không truyền")
    void createLesson_autoOrderIndex() {
        UUID chapterId = UUID.randomUUID();
        when(chapterQueryPort.findById(chapterId)).thenReturn(Optional.of(chapter(chapterId, false)));
        when(lessonQueryPort.findMaxOrderIndexByChapterId(chapterId)).thenReturn(Optional.of(2));
        when(lessonCommandPort.save(org.mockito.ArgumentMatchers.any(Lesson.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Lesson lesson =
                createLessonService.create(
                        new CreateLessonUseCase.CreateLessonCommand(chapterId, "Lesson 3", false));

        assertEquals(3, lesson.getOrderIndex());
    }

    @Test
    @DisplayName("Tạo lesson trong chapter không tồn tại phải ném ngoại lệ")
    void createLesson_notFound() {
        UUID chapterId = UUID.randomUUID();
        when(chapterQueryPort.findById(chapterId)).thenReturn(Optional.empty());

        assertThrows(
                ResourceNotFoundException.class,
                () ->
                        createLessonService.create(
                                new CreateLessonUseCase.CreateLessonCommand(
                                        chapterId, "Lesson", false)));
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
}
