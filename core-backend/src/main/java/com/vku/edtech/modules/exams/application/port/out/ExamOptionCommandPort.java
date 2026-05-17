package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;

public interface ExamOptionCommandPort {
    ExamQuestionOption save(ExamQuestionOption option);

    void deleteById(java.util.UUID optionId);
}
