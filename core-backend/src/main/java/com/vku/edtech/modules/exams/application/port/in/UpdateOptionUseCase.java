package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import java.util.UUID;

public interface UpdateOptionUseCase {
    ExamQuestionOption update(UpdateOptionCommand command);

    record UpdateOptionCommand(UUID optionId, String content, Boolean correct, Integer orderIndex) {}
}
