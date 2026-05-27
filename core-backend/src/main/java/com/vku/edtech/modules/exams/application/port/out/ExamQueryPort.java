package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.domain.model.Exam;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ExamQueryPort {
    Optional<Exam> findById(UUID examId);

    List<Exam> findAll();

    List<Exam> findAllActive();

    List<Exam> findAllByStatus(String status);
}
