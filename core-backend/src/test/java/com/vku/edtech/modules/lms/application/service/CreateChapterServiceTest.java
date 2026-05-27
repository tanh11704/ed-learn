package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.port.in.CreateChapterUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class CreateChapterServiceTest {

    @Mock private ChapterCommandPort chapterCommandPort;
    @Mock private ChapterQueryPort chapterQueryPort;

    @InjectMocks private CreateChapterService createChapterService;

    @Test
    @DisplayName("Tạo chapter mới sẽ tự tăng orderIndex khi orderIndex <= 0")
    void createChapter_autoOrderIndex() {
        UUID courseId = UUID.randomUUID();
        when(chapterQueryPort.findMaxOrderIdxByCourseId(courseId)).thenReturn(3);
        when(chapterCommandPort.save(org.mockito.ArgumentMatchers.any(Chapter.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Chapter chapter =
                createChapterService.createChapter(
                        new CreateChapterUseCase.CreateChapterCommand(courseId, "Chapter 4", 0));

        assertEquals(4, chapter.getOrderIndex());
    }

    @Test
    @DisplayName("Create chapter ignores requested orderIndex")
    void createChapter_ignoresRequestedOrderIndex() {
        UUID courseId = UUID.randomUUID();
        when(chapterQueryPort.findMaxOrderIdxByCourseId(courseId)).thenReturn(1);
        when(chapterCommandPort.save(org.mockito.ArgumentMatchers.any(Chapter.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Chapter chapter =
                createChapterService.createChapter(
                        new CreateChapterUseCase.CreateChapterCommand(courseId, "Chapter 2", 1));

        assertEquals(2, chapter.getOrderIndex());
    }
}
