package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.application.dto.DashboardSummaryResult;
import com.vku.edtech.modules.lms.application.dto.MonthlyEnrollmentResult;
import com.vku.edtech.modules.lms.application.dto.TopCourseResult;
import java.util.List;

public interface StatisticsQueryPort {
    List<TopCourseResult> getTopCourses(int limit);

    DashboardSummaryResult getDashboardSummary();

    List<MonthlyEnrollmentResult> getMonthlyEnrollments(int year);
}
