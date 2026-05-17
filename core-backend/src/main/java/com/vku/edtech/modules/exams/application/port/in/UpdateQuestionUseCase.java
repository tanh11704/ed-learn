package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import java.util.UUID;

public interface UpdateQuestionUseCase {
    ExamQuestion update(UpdateQuestionCommand command);

    record UpdateQuestionCommand(UUID questionId, String content, Integer orderIndex) {}
}
