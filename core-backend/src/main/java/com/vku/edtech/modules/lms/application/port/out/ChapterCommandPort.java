package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import java.util.List;
import java.util.UUID;

public interface ChapterCommandPort {
    Chapter save(Chapter chapter);

    Chapter delete(UUID id);

    List<UUID> findActiveChapterIdsByCourseId(UUID courseId);

    void updateOrderIndex(UUID chapterId, int orderIndex);

    void flush();
}
