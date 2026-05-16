package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.port.in.UpdateChapterUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
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
class UpdateChapterServiceTest {

    @Mock private ChapterQueryPort chapterQueryPort;
    @Mock private ChapterCommandPort chapterCommandPort;
    @Mock private CourseQueryPort courseQueryPort;

    @InjectMocks private UpdateChapterService updateChapterService;

    @Test
    @DisplayName("Update chapter thành công")
    void updateChapter_success() {
        UUID chapterId = UUID.randomUUID();
        UUID courseId = UUID.randomUUID();
        Chapter chapter = chapter(chapterId, courseId, "Old", 1);

        when(chapterQueryPort.findById(chapterId)).thenReturn(Optional.of(chapter));
        when(courseQueryPort.findByIdWithChapters(courseId))
                .thenReturn(Optional.of(course(courseId)));
        when(chapterCommandPort.save(org.mockito.ArgumentMatchers.any(Chapter.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Chapter updated =
                updateChapterService.updateChapter(
                        new UpdateChapterUseCase.UpdateChapterCommand(
                                chapterId, courseId, "New", 2));

        assertEquals("New", updated.getTitle());
        assertEquals(2, updated.getOrderIndex());
        verify(chapterCommandPort).save(org.mockito.ArgumentMatchers.any(Chapter.class));
    }

    @Test
    @DisplayName("Update chapter không tồn tại phải ném ngoại lệ")
    void updateChapter_notFound() {
        UUID chapterId = UUID.randomUUID();
        when(chapterQueryPort.findById(chapterId)).thenReturn(Optional.empty());

        assertThrows(
                ResourceNotFoundException.class,
                () ->
                        updateChapterService.updateChapter(
                                new UpdateChapterUseCase.UpdateChapterCommand(
                                        chapterId, null, "New", 1)));
    }

    private Chapter chapter(UUID id, UUID courseId, String title, int orderIndex) {
        Instant now = Instant.now();
        return Chapter.builder()
                .id(id)
                .courseId(courseId)
                .title(title)
                .orderIndex(orderIndex)
                .isDeleted(false)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }

    private Course course(UUID id) {
        Instant now = Instant.now();
        return Course.builder().id(id).title("t").description("d").subject("s").createdAt(now).updatedAt(now).build();
    }
}
