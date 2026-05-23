package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamBadRequestException;
import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.StartExamAttemptUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class StartExamAttemptService implements StartExamAttemptUseCase {

    private final ExamQueryPort examQueryPort;
    private final ExamAttemptCommandPort attemptCommandPort;

    @Override
    @Transactional
    public ExamAttempt start(StartExamAttemptCommand command) {
        Exam exam =
                examQueryPort
                        .findById(command.examId())
                        .orElseThrow(() -> new ExamNotFoundException("Khong tim thay de thi"));
        if (!"PUBLISHED".equals(exam.getStatus())) {
            throw new ExamBadRequestException("Chi co the bat dau lam de da xuat ban");
        }

        return attemptCommandPort.save(
                ExamAttempt.start(
                        command.examId(),
                        command.userId(),
                        command.gradeLevel(),
                        command.className()));
    }
}
