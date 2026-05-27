package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record LessonContentItemResponse(
        UUID id,
        UUID lessonId,
        String type,
        String prompt,
        String answer,
        String explanation,
        List<String> options,
        String correctOption,
        Integer orderIndex,
        Integer repetitionCount,
        Double easeFactor,
        Integer intervalDays,
        Instant nextReviewDate) {}
