package com.vku.edtech.modules.lms.application.port.in;

import java.util.List;
import java.util.UUID;

public interface ReorderLessonsUseCase {
    void reorder(ReorderLessonsCommand command);

    record ReorderLessonsCommand(UUID chapterId, List<UUID> lessonIds) {}
}
