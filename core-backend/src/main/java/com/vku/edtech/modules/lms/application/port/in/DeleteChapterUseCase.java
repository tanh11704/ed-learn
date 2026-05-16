package com.vku.edtech.modules.lms.application.port.in;

import java.util.UUID;

public interface DeleteChapterUseCase {
    void deleteChapter(DeleteChapterCommand command);

    record DeleteChapterCommand(UUID chapterId) {}
}
