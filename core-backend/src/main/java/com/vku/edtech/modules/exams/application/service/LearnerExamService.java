package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamBadRequestException;
import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.StartExamAttemptUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptAnswerQueryPort;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptQueryPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import com.vku.edtech.modules.exams.domain.model.ExamAttemptAnswer;
import com.vku.edtech.modules.exams.domain.model.ExamAttemptStatus;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class LearnerExamService {

    private final ExamQueryPort examQueryPort;
    private final ExamAttemptQueryPort attemptQueryPort;
    private final ExamAttemptAnswerQueryPort answerQueryPort;
    private final StartExamAttemptUseCase startExamAttemptUseCase;

    @Transactional(readOnly = true)
    public List<Exam> getPublishedExams() {
        return examQueryPort.findAllByStatus("PUBLISHED");
    }

    @Transactional(readOnly = true)
    public Exam getPublishedExam(UUID examId) {
        Exam exam = getExam(examId);
        ensurePublished(exam);
        return exam;
    }

    @Transactional
    public ExamAttempt startAttempt(
            UUID examId, UUID userId, Integer gradeLevel, String className) {
        return startExamAttemptUseCase.start(
                new StartExamAttemptUseCase.StartExamAttemptCommand(
                        examId, userId, gradeLevel, className));
    }

    @Transactional(readOnly = true)
    public ExamAttempt getOwnedAttempt(UUID attemptId, UUID userId) {
        ExamAttempt attempt = getAttempt(attemptId);
        ensureOwner(attempt, userId);
        return attempt;
    }

    @Transactional(readOnly = true)
    public Exam getExamForAttempt(ExamAttempt attempt) {
        return getExam(attempt.getExamId());
    }

    @Transactional(readOnly = true)
    public List<ExamAttemptAnswer> getReviewAnswers(UUID attemptId, UUID userId) {
        ExamAttempt attempt = getOwnedAttempt(attemptId, userId);
        if (attempt.getStatus() != ExamAttemptStatus.SUBMITTED
                && attempt.getStatus() != ExamAttemptStatus.GRADED) {
            throw new ExamBadRequestException("Chi co the xem lai bai sau khi da nop");
        }
        return answerQueryPort.findAllByAttemptId(attemptId);
    }

    private Exam getExam(UUID examId) {
        return examQueryPort
                .findById(examId)
                .orElseThrow(() -> new ExamNotFoundException("Khong tim thay de thi"));
    }

    private ExamAttempt getAttempt(UUID attemptId) {
        return attemptQueryPort
                .findById(attemptId)
                .orElseThrow(() -> new ExamNotFoundException("Khong tim thay luot lam de"));
    }

    private void ensurePublished(Exam exam) {
        if (!"PUBLISHED".equals(exam.getStatus())) {
            throw new ExamNotFoundException("Khong tim thay de thi");
        }
    }

    private void ensureOwner(ExamAttempt attempt, UUID userId) {
        if (!attempt.getUserId().equals(userId)) {
            throw new ExamBadRequestException("Luot lam de khong thuoc user hien tai");
        }
    }
}
