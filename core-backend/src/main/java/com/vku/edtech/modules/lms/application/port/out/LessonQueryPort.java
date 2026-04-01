package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import java.util.Optional;
import java.util.UUID;

public interface LessonQueryPort {
    Optional<Lesson> findById(UUID id);

    Optional<Lesson> findByIdAndNotDeleted(UUID id);

    Optional<Integer> findMaxOrderIndexByChapterId(UUID chapterId);

    Optional<UUID> findCourseIdByLessonId(UUID lessonId);
}
