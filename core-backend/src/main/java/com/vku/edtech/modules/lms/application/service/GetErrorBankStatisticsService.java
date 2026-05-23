package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.dto.ErrorBankStudentStatisticResult;
import com.vku.edtech.modules.lms.application.port.in.GetErrorBankStatisticsUseCase;
import com.vku.edtech.modules.lms.application.port.out.ErrorBankQueryPort;
import java.time.Instant;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetErrorBankStatisticsService implements GetErrorBankStatisticsUseCase {

    private final ErrorBankQueryPort errorBankQueryPort;

    @Override
    public List<ErrorBankStudentStatisticResult> getStudentStatistics() {
        return errorBankQueryPort.getStudentStatistics(Instant.now());
    }
}
