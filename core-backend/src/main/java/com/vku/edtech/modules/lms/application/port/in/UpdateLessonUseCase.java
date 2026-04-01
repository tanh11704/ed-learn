package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import java.util.UUID;

public interface UpdateLessonUseCase {
    Lesson update(UpdateLessonCommand command);

    record UpdateLessonCommand(
            UUID lessonId, UUID chapterId, String title, Integer orderIndex, Boolean isPreview) {}
}
