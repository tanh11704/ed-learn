package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.dto.MonthlyEnrollmentResult;
import com.vku.edtech.modules.lms.application.port.in.GetMonthlyEnrollmentsUseCase;
import com.vku.edtech.modules.lms.application.port.out.StatisticsQueryPort;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetMonthlyEnrollmentsService implements GetMonthlyEnrollmentsUseCase {

    private final StatisticsQueryPort statisticsQueryPort;

    @Override
    public List<MonthlyEnrollmentResult> getMonthlyEnrollments(GetMonthlyEnrollmentsQuery query) {
        return statisticsQueryPort.getMonthlyEnrollments(query.year());
    }
}
