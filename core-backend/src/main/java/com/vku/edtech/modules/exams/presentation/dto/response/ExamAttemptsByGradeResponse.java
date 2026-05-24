package com.vku.edtech.modules.exams.presentation.dto.response;

public record ExamAttemptsByGradeResponse(
        Integer gradeLevel, long attemptCount, long submittedCount, Double averageScore) {}
