package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.Exam;

public interface CreateExamUseCase {
    Exam create(CreateExamCommand command);

    record CreateExamCommand(
            String title,
            String subject,
            Integer schoolYear,
            Integer durationMinutes,
            Integer totalQuestions,
            String description) {}
}
