package com.vku.edtech.modules.exams.presentation.dto.response;

import java.util.UUID;

public record LearnerExamSummaryResponse(
        UUID id,
        String title,
        String subject,
        Integer schoolYear,
        Integer durationMinutes,
        Integer totalQuestions,
        String description,
        String status) {}
