package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;

public interface ExamQuestionCommandPort {
    ExamQuestion save(ExamQuestion question);

    void deleteById(java.util.UUID questionId);
}
