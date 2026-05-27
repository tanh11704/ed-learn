package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ChapterQueryPort {
    Optional<Chapter> findById(UUID id);

    List<Chapter> findAllByCourseIdWithLessons(UUID courseId, String status);

    int findMaxOrderIdxByCourseId(UUID courseId);

    void lockCourseForOrdering(UUID courseId);
}
