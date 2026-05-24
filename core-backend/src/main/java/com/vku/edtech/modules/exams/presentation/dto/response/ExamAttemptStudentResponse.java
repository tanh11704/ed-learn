package com.vku.edtech.modules.exams.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record ExamAttemptStudentResponse(
        UUID attemptId,
        UUID examId,
        UUID studentId,
        String studentName,
        String email,
        Integer gradeLevel,
        String className,
        String status,
        Instant startedAt,
        Instant submittedAt,
        Integer durationSeconds,
        Double score,
        Double maxScore) {}
