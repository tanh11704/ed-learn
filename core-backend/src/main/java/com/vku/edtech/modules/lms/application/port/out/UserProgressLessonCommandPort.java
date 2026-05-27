package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.UserProgressLesson;
import java.util.UUID;

public interface UserProgressLessonCommandPort {
    UserProgressLesson save(UserProgressLesson userProgressLesson);

    boolean markCompleted(UUID userId, UUID lessonId);
}
