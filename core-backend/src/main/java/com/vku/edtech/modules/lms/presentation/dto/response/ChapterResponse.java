package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record ChapterResponse(
        UUID id,
        UUID courseId,
        String title,
        Integer orderIndex,
        List<LessonResponse> lessons,
        Boolean isDeleted,
        Instant createdAt,
        Instant updatedAt) {}
