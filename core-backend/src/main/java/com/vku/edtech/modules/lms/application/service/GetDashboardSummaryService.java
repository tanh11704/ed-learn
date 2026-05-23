package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.dto.DashboardSummaryResult;
import com.vku.edtech.modules.lms.application.port.in.GetDashboardSummaryUseCase;
import com.vku.edtech.modules.lms.application.port.out.StatisticsQueryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetDashboardSummaryService implements GetDashboardSummaryUseCase {

    private final StatisticsQueryPort statisticsQueryPort;

    @Override
    public DashboardSummaryResult getDashboardSummary(GetDashboardSummaryQuery query) {
        return statisticsQueryPort.getDashboardSummary();
    }
}
