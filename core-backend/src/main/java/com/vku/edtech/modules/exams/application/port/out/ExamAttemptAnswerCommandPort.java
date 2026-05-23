package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.domain.model.ExamAttemptAnswer;
import java.util.List;

public interface ExamAttemptAnswerCommandPort {
    void saveAll(List<ExamAttemptAnswer> answers);
}
