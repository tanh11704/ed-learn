package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamBadRequestException;
import com.vku.edtech.modules.exams.application.port.in.CreateExamUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamCommandPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamStructure;
import com.vku.edtech.modules.exams.domain.model.Thpt2026ExamProfile;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateExamService implements CreateExamUseCase {

    private final ExamCommandPort examCommandPort;

    @Override
    @Transactional
    public Exam create(CreateExamCommand command) {
        validateThpt2026Metadata(command.subject(), command.durationMinutes(), command.totalQuestions());
        Exam exam =
                Exam.createNew(
                        command.title(),
                        command.subject(),
                        command.schoolYear(),
                        command.durationMinutes(),
                        command.totalQuestions(),
                        command.description());
        return examCommandPort.save(exam);
    }

    private void validateThpt2026Metadata(String subject, Integer durationMinutes, Integer totalQuestions) {
        if (!Thpt2026ExamProfile.supports(subject)) {
            return;
        }

        ExamStructure structure = ExamStructure.thpt2026(subject);
        if (!Integer.valueOf(structure.durationMinutes()).equals(durationMinutes)) {
            throw new ExamBadRequestException("Thời gian làm bài không khớp cấu trúc THPT 2026");
        }
        if (!Integer.valueOf(structure.totalQuestions()).equals(totalQuestions)) {
            throw new ExamBadRequestException("Tổng số câu hỏi không khớp cấu trúc THPT 2026");
        }
    }
}
