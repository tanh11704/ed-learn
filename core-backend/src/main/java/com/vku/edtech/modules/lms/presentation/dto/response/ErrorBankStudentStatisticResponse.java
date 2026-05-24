package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record ErrorBankStudentStatisticResponse(
        UUID studentId,
        String studentName,
        String email,
        Integer gradeLevel,
        String className,
        long totalErrors,
        long dueErrors,
        long reviewedErrors,
        long masteredErrors,
        Double averageEaseFactor,
        Double averageIntervalDays,
        Instant nextReviewDate,
        Instant lastUpdatedAt) {}
