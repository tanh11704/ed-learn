package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import java.util.UUID;

public interface CreateLessonUseCase {
    Lesson create(CreateLessonCommand command);

    record CreateLessonCommand(
            UUID chapterId, String title, Integer orderIndex, boolean isPreview) {}
}
