package com.vku.edtech.modules.lms.application.dto;

import java.time.Instant;
import java.util.UUID;

public record ErrorBankStudentStatisticResult(
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
