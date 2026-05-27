package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.UserCourseProgress;
import java.util.UUID;

public interface UserCourseProgressCommandPort {
    UserCourseProgress save(UserCourseProgress userCourseProgress);

    void upsertProgress(UUID userId, UUID courseId, int progressPercent, UUID lastAccessedLessonId);
}
