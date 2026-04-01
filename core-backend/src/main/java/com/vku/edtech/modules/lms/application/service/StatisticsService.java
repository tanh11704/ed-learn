package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.dto.DashboardSummaryResult;
import com.vku.edtech.modules.lms.application.dto.MonthlyEnrollmentResult;
import com.vku.edtech.modules.lms.application.dto.TopCourseResult;
import com.vku.edtech.modules.lms.application.port.in.GetDashboardSummaryUseCase;
import com.vku.edtech.modules.lms.application.port.in.GetMonthlyEnrollmentsUseCase;
import com.vku.edtech.modules.lms.application.port.in.GetTopCoursesUseCase;
import com.vku.edtech.modules.lms.application.port.out.StatisticsQueryPort;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StatisticsService
        implements GetTopCoursesUseCase, GetDashboardSummaryUseCase, GetMonthlyEnrollmentsUseCase {

    private final StatisticsQueryPort statisticsQueryPort;

    @Override
    public DashboardSummaryResult getDashboardSummary(GetDashboardSummaryQuery query) {
        return statisticsQueryPort.getDashboardSummary();
    }

    @Override
    public List<MonthlyEnrollmentResult> getMonthlyEnrollments(GetMonthlyEnrollmentsQuery query) {
        return statisticsQueryPort.getMonthlyEnrollments(query.year());
    }

    @Override
    public List<TopCourseResult> getTopCourses(GetTopCoursesQuery query) {
        return statisticsQueryPort.getTopCourses(query.limit());
    }
}
