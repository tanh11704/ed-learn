package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ExamOptionQueryPort {
    Optional<ExamQuestionOption> findById(UUID optionId);

    List<ExamQuestionOption> findAllByQuestionId(UUID questionId);
}
