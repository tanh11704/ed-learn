package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.UserProgressLesson;

public interface UserProgressLessonCommandPort {
    UserProgressLesson save(UserProgressLesson userProgressLesson);
}
