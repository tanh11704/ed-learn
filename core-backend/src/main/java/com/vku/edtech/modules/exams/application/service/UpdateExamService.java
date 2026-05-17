package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamBadRequestException;
import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.UpdateExamUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamStructure;
import com.vku.edtech.modules.exams.domain.model.Thpt2026ExamProfile;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateExamService implements UpdateExamUseCase {

    private final ExamQueryPort examQueryPort;
    private final ExamCommandPort examCommandPort;

    @Override
    @Transactional
    public Exam update(UpdateExamCommand command) {
        Exam exam =
                examQueryPort
                        .findById(command.examId())
                        .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy đề thi"));

        if (command.status() != null
                && !command.status().equals("DRAFT")
                && !command.status().equals("PUBLISHED")
                && !command.status().equals("ARCHIVED")) {
            throw new ExamBadRequestException("Trạng thái đề thi không hợp lệ");
        }

        String subject = command.subject() == null ? exam.getSubject() : command.subject();
        Integer durationMinutes =
                command.durationMinutes() == null ? exam.getDurationMinutes() : command.durationMinutes();
        Integer totalQuestions =
                command.totalQuestions() == null ? exam.getTotalQuestions() : command.totalQuestions();
        validateThpt2026Metadata(subject, durationMinutes, totalQuestions);

        exam.updateDetails(
                command.title(),
                command.subject(),
                command.schoolYear(),
                command.durationMinutes(),
                command.totalQuestions(),
                command.description());
        if (command.status() != null) {
            exam.setStatus(command.status());
        }

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
