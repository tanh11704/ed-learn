package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.UserProgressLesson;
import java.util.Optional;
import java.util.UUID;

public interface UserProgressLessonQueryPort {
    Optional<UserProgressLesson> findByUserIdAndLessonId(UUID userId, UUID lessonId);

    long countCompletedByUserIdAndCourseId(UUID userId, UUID courseId);
}
