package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.domain.model.ExamAttemptAnswer;
import java.util.List;
import java.util.UUID;

public interface ExamAttemptAnswerQueryPort {
    List<ExamAttemptAnswer> findAllByAttemptId(UUID attemptId);
}
