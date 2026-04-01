package com.vku.edtech.modules.lms.application.port.in;

import java.util.UUID;

public interface DeleteLessonUseCase {
    void delete(DeleteLessonCommand command);

    record DeleteLessonCommand(UUID lessonId) {}
}
