package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.DeleteChapterUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteChapterService implements DeleteChapterUseCase {

    private final ChapterQueryPort chapterQueryPort;
    private final ChapterCommandPort chapterCommandPort;

    @Override
    @Transactional
    public void deleteChapter(DeleteChapterCommand command) {
        Chapter chapter =
                chapterQueryPort
                        .findById(command.chapterId())
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy chapter"));

        if (Boolean.TRUE.equals(chapter.getIsDeleted())) {
            return;
        }

        chapterCommandPort.delete(command.chapterId());
    }
}
