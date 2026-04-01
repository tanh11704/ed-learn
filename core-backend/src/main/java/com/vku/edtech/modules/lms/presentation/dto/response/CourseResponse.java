package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record CourseResponse(
        UUID id,
        String title,
        String description,
        String subject,
        String thumbnailUrl,
        List<ChapterResponse> chapters,
        Instant createdAt,
        Instant updatedAt) {}
