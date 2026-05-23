package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import java.util.List;
import java.util.UUID;

public interface SubmitExamAttemptUseCase {
    ExamAttempt submit(SubmitExamAttemptCommand command);

    record SubmitExamAttemptCommand(UUID attemptId, UUID userId, List<SubmitAnswerCommand> answers) {}

    record SubmitAnswerCommand(UUID questionId, UUID selectedOptionId, String answerText) {}
}
