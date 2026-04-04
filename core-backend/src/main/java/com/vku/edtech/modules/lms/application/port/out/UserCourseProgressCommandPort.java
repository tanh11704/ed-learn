package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.UserCourseProgress;

public interface UserCourseProgressCommandPort {
    UserCourseProgress save(UserCourseProgress userCourseProgress);
}
