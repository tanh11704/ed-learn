package com.vku.edtech.modules.lms.application.dto;

public record DashboardSummaryResult(
        long totalStudents,
        long totalActiveCourses,
        long currentMonthEnrollments,
        long currentMonthRevenue) {}
