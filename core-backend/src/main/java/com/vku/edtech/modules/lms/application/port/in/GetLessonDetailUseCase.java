package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import java.util.UUID;

public interface GetLessonDetailUseCase {
    Lesson getLessonDetail(GetLessonDetailQuery query);

    record GetLessonDetailQuery(UUID lessonId) {}
}
