package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.port.in.GetMyExamAttemptsUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetMyExamAttemptsService implements GetMyExamAttemptsUseCase {

    private final ExamAttemptQueryPort attemptQueryPort;

    @Override
    @Transactional(readOnly = true)
    public List<ExamAttempt> getMyAttempts(UUID userId) {
        return attemptQueryPort.findByUserId(userId);
    }
}
