package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import java.util.List;
import java.util.UUID;

public interface GetOptionsUseCase {
    List<ExamQuestionOption> getOptionsByQuestionId(UUID questionId);
}
