package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.Exam;
import java.util.UUID;

public interface GetExamUseCase {
    Exam getExam(GetExamQuery query);

    record GetExamQuery(UUID examId) {}
}
