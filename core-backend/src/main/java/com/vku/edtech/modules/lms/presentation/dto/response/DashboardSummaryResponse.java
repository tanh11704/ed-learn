package com.vku.edtech.modules.lms.presentation.dto.response;

public record DashboardSummaryResponse(
        long totalStudents,
        long totalActiveCourses,
        long currentMonthEnrollments,
        long currentMonthRevenue) {}
