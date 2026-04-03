package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.UserCourseProgress;
import java.util.Optional;
import java.util.UUID;

public interface UserCourseProgressQueryPort {
    Optional<UserCourseProgress> findByUserIdAndCourseId(UUID userId, UUID courseId);
}
