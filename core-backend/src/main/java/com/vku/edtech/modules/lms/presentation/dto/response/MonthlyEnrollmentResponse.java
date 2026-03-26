package com.vku.edtech.modules.lms.presentation.dto.response;

public record MonthlyEnrollmentResponse(
        int month,
        int year,
        long enrollments
) {}
