package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record LessonResponse(
        UUID id,
        UUID chapterId,
        String title,
        String videoUrl,
        String pdfUrl,
        Integer orderIndex,
        Boolean isPreview,
        Boolean isDeleted,
        Instant createdAt,
        Instant updatedAt) {}
