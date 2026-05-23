package com.vku.edtech.modules.exams.presentation.dto.response;

import java.util.UUID;

public record ExamAttemptSummaryResponse(
        UUID examId,
        String examTitle,
        long attemptCount,
        long submittedCount,
        Double averageScore,
        Double highestScore,
        Double lowestScore) {}
