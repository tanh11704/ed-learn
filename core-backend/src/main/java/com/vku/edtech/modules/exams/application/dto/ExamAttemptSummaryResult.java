package com.vku.edtech.modules.exams.application.dto;

import java.util.UUID;

public record ExamAttemptSummaryResult(
        UUID examId,
        String examTitle,
        long attemptCount,
        long submittedCount,
        Double averageScore,
        Double highestScore,
        Double lowestScore) {}
