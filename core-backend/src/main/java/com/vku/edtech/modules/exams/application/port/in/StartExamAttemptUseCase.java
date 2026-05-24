package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import java.util.UUID;

public interface StartExamAttemptUseCase {
    ExamAttempt start(StartExamAttemptCommand command);

    record StartExamAttemptCommand(
            UUID examId, UUID userId, Integer gradeLevel, String className) {}
}
