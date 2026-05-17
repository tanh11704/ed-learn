package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ExamQuestionQueryPort {
    Optional<ExamQuestion> findById(UUID questionId);

    List<ExamQuestion> findAllByExamId(UUID examId);
}
