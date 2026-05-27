package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import java.util.List;
import java.util.UUID;

public interface LessonCommandPort {
    Lesson save(Lesson lesson);

    List<UUID> findActiveLessonIdsByChapterId(UUID chapterId);

    void updateOrderIndex(UUID lessonId, int orderIndex);

    void flush();
}
