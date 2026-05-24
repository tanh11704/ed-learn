package com.vku.edtech.modules.exams.application.dto;

public record ExamAttemptsByGradeResult(
        Integer gradeLevel, long attemptCount, long submittedCount, Double averageScore) {}
