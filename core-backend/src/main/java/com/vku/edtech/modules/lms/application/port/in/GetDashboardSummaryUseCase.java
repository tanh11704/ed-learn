package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.application.dto.DashboardSummaryResult;

public interface GetDashboardSummaryUseCase {
    DashboardSummaryResult getDashboardSummary(GetDashboardSummaryQuery query);

    record GetDashboardSummaryQuery() {}
}
