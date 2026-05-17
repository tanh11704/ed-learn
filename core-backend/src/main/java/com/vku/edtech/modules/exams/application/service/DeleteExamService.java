package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.DeleteExamUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteExamService implements DeleteExamUseCase {

    private final ExamQueryPort examQueryPort;
    private final ExamCommandPort examCommandPort;

    @Override
    @Transactional
    public void delete(DeleteExamCommand command) {
        Exam exam =
                examQueryPort
                        .findById(command.examId())
                        .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy đề thi"));
        exam.setStatus("ARCHIVED");
        examCommandPort.save(exam);
    }
}
