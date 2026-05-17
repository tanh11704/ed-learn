package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.Exam;
import java.util.UUID;

public interface UpdateExamUseCase {
    Exam update(UpdateExamCommand command);

    record UpdateExamCommand(
            UUID examId,
            String title,
            String subject,
            Integer schoolYear,
            Integer durationMinutes,
            Integer totalQuestions,
            String description,
            String status) {}
}
