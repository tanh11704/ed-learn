package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.port.in.DeleteChapterUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
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
class DeleteChapterServiceTest {

    @Mock private ChapterQueryPort chapterQueryPort;
    @Mock private ChapterCommandPort chapterCommandPort;

    @InjectMocks private DeleteChapterService deleteChapterService;

    @Test
    @DisplayName("Xóa chapter sẽ gọi delete ở port")
    void deleteChapter_success() {
        UUID chapterId = UUID.randomUUID();
        when(chapterQueryPort.findById(chapterId)).thenReturn(Optional.of(chapter(chapterId, false)));

        deleteChapterService.deleteChapter(new DeleteChapterUseCase.DeleteChapterCommand(chapterId));

        verify(chapterCommandPort).delete(chapterId);
    }

    @Test
    @DisplayName("Xóa chapter không tồn tại phải ném ngoại lệ")
    void deleteChapter_notFound() {
        UUID chapterId = UUID.randomUUID();
        when(chapterQueryPort.findById(chapterId)).thenReturn(Optional.empty());

        assertThrows(
                ResourceNotFoundException.class,
                () -> deleteChapterService.deleteChapter(new DeleteChapterUseCase.DeleteChapterCommand(chapterId)));
    }

    private Chapter chapter(UUID id, boolean deleted) {
        Instant now = Instant.now();
        return Chapter.builder().id(id).title("t").orderIndex(1).isDeleted(deleted).createdAt(now).updatedAt(now).build();
    }
}
