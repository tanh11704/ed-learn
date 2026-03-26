package com.vku.edtech.modules.lms.application.dto;

public record MonthlyEnrollmentResult(
        int month,
        int year,
        long enrollments
) {
}
