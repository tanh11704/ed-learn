package com.vku.edtech.modules.exams.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record ExamResponse(
        UUID id,
        String title,
        String subject,
        Integer schoolYear,
        Integer durationMinutes,
        Integer totalQuestions,
        String description,
        String status,
        Instant createdAt,
        Instant updatedAt) {}
