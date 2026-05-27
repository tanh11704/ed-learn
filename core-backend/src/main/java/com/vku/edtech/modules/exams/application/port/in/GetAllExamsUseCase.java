package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.Exam;
import java.util.List;

public interface GetAllExamsUseCase {
    List<Exam> getAllExams(String status);
}
