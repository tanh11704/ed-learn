package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import java.util.UUID;

public interface UpdateChapterUseCase {
    Chapter updateChapter(UpdateChapterCommand command);

    record UpdateChapterCommand(UUID chapterId, UUID courseId, String title) {}
}
