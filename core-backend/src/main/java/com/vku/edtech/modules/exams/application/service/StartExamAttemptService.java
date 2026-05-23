package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.StartExamAttemptUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
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
        examQueryPort
                .findById(command.examId())
                .orElseThrow(() -> new ExamNotFoundException("Khong tim thay de thi"));

        return attemptCommandPort.save(
                ExamAttempt.start(
                        command.examId(),
                        command.userId(),
                        command.gradeLevel(),
                        command.className()));
    }
}
