package com.vku.edtech.modules.exams.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record ExamAttemptResponse(
        UUID id,
        UUID examId,
        UUID userId,
        Integer gradeLevel,
        String className,
        String status,
        Instant startedAt,
        Instant submittedAt,
        Integer durationSeconds,
        Double score,
        Double maxScore) {}
