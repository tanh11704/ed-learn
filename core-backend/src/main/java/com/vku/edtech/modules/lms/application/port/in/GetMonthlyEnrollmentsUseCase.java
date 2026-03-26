package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.application.dto.MonthlyEnrollmentResult;

import java.util.List;

public interface GetMonthlyEnrollmentsUseCase {
    List<MonthlyEnrollmentResult> getMonthlyEnrollments(GetMonthlyEnrollmentsQuery query);

    record GetMonthlyEnrollmentsQuery(int year) {
    }
}
