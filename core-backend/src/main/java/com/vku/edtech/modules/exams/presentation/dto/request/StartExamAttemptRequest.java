package com.vku.edtech.modules.exams.presentation.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record StartExamAttemptRequest(
        @NotNull(message = "gradeLevel khong duoc de trong")
                @Min(value = 1, message = "gradeLevel khong hop le")
                @Max(value = 12, message = "gradeLevel khong hop le")
                Integer gradeLevel,
        String className) {}
