package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import java.util.List;
import java.util.UUID;

public interface GetQuestionsUseCase {
    List<ExamQuestion> getQuestionsByExamId(UUID examId);
}
