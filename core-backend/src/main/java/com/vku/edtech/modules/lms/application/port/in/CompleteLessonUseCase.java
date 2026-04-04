package com.vku.edtech.modules.lms.application.port.in;

import java.util.UUID;

public interface CompleteLessonUseCase {
    void complete(CompleteLessonCommand command);

    record CompleteLessonCommand(UUID userId, UUID lessonId) {}
}
