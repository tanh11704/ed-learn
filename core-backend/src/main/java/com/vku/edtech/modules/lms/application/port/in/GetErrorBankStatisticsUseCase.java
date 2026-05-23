package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.application.dto.ErrorBankStudentStatisticResult;
import java.util.List;

public interface GetErrorBankStatisticsUseCase {
    List<ErrorBankStudentStatisticResult> getStudentStatistics();
}
