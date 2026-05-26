package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import java.util.UUID;

public interface UpdateLessonVideoUrlUseCase {
    Lesson updateVideoUrl(UpdateLessonVideoUrlCommand command);

    record UpdateLessonVideoUrlCommand(UUID lessonId, String videoUrl) {}
}
