package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import java.util.UUID;

public interface CreateOptionUseCase {
    ExamQuestionOption create(CreateOptionCommand command);

    record CreateOptionCommand(
            UUID questionId, String content, boolean correct, Integer orderIndex) {}
}
