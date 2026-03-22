package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Lesson;

public interface LessonCommandPort {
    Lesson save(Lesson lesson);
}
