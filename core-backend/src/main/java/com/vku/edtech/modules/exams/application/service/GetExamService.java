package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.GetExamUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetExamService implements GetExamUseCase {

    private final ExamQueryPort examQueryPort;

    @Override
    @Transactional(readOnly = true)
    public Exam getExam(GetExamQuery query) {
        return examQueryPort
                .findById(query.examId())
                .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy đề thi"));
    }
}
