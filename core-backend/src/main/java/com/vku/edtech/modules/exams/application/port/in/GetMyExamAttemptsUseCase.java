package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import java.util.List;
import java.util.UUID;

public interface GetMyExamAttemptsUseCase {
    List<ExamAttempt> getMyAttempts(UUID userId);
}
