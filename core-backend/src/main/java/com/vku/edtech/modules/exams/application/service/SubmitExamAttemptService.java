package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamBadRequestException;
import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.SubmitExamAttemptUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptAnswerCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptQueryPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import com.vku.edtech.modules.exams.domain.model.ExamAttemptAnswer;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamStructure;
import com.vku.edtech.modules.exams.domain.model.Thpt2026ExamProfile;
import com.vku.edtech.modules.exams.domain.service.ExamScoringEngine;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class SubmitExamAttemptService implements SubmitExamAttemptUseCase {

    private final ExamScoringEngine scoringEngine = new ExamScoringEngine();
    private final ExamAttemptQueryPort attemptQueryPort;
    private final ExamAttemptCommandPort attemptCommandPort;
    private final ExamAttemptAnswerCommandPort answerCommandPort;
    private final ExamQueryPort examQueryPort;

    @Override
    @Transactional
    public ExamAttempt submit(SubmitExamAttemptCommand command) {
        ExamAttempt attempt =
                attemptQueryPort
                        .findById(command.attemptId())
                        .orElseThrow(() -> new ExamNotFoundException("Khong tim thay luot lam de"));
        if (!attempt.getUserId().equals(command.userId())) {
            throw new ExamBadRequestException("Luot lam de khong thuoc user hien tai");
        }

        Exam exam =
                examQueryPort
                        .findById(attempt.getExamId())
                        .orElseThrow(() -> new ExamNotFoundException("Khong tim thay de thi"));
        Map<UUID, SubmitAnswerCommand> submittedAnswers = toSubmittedAnswerMap(command.answers());
        validateQuestionIds(exam, submittedAnswers);
        List<ExamScoringEngine.QuestionAnswer> scoringAnswers =
                exam.getQuestions().stream()
                        .map(
                                question ->
                                        new ExamScoringEngine.QuestionAnswer(
                                                question.getId(),
                                                resolveUserAnswer(
                                                        question, submittedAnswers.get(question.getId()))))
                        .toList();
        var scoringResult = scoringEngine.score(exam, scoringAnswers);
        ExamStructure scoringStructure =
                Thpt2026ExamProfile.supports(exam.getSubject())
                        ? ExamStructure.thpt2026(exam.getSubject())
                        : null;

        List<ExamAttemptAnswer> answers =
                exam.getQuestions().stream()
                        .map(
                                question ->
                                        buildAnswer(
                                                attempt.getId(),
                                                scoringStructure,
                                                question,
                                                submittedAnswers.get(question.getId())))
                        .toList();

        answerCommandPort.saveAll(answers);
        attempt.submit(
                scoringResult.totalScore().doubleValue(), scoringResult.maxScore().doubleValue());
        return attemptCommandPort.save(attempt);
    }

    private Map<UUID, SubmitAnswerCommand> toSubmittedAnswerMap(List<SubmitAnswerCommand> answers) {
        try {
            return answers.stream()
                    .collect(Collectors.toMap(SubmitAnswerCommand::questionId, answer -> answer));
        } catch (IllegalStateException ex) {
            throw new ExamBadRequestException("Mot cau hoi chi duoc nop mot cau tra loi");
        }
    }

    private void validateQuestionIds(Exam exam, Map<UUID, SubmitAnswerCommand> submittedAnswers) {
        var questionIds =
                exam.getQuestions().stream().map(ExamQuestion::getId).collect(Collectors.toSet());
        boolean hasInvalidQuestion =
                submittedAnswers.keySet().stream()
                        .anyMatch(questionId -> !questionIds.contains(questionId));
        if (hasInvalidQuestion) {
            throw new ExamBadRequestException("Cau hoi khong thuoc de thi cua luot lam");
        }
    }

    private ExamAttemptAnswer buildAnswer(
            UUID attemptId,
            ExamStructure scoringStructure,
            ExamQuestion question,
            SubmitAnswerCommand answer) {
        String userAnswer = resolveUserAnswer(question, answer);
        ExamQuestionScoringRule rule =
                scoringStructure == null
                        ? null
                        : scoringStructure
                                .findRule(question.getQuestionType(), question.getPaperPart())
                                .orElse(null);
        BigDecimal score = scoringEngine.scoreQuestion(question, rule, userAnswer);
        return ExamAttemptAnswer.create(
                attemptId,
                question.getId(),
                answer == null ? null : answer.selectedOptionId(),
                userAnswer,
                score.compareTo(BigDecimal.ZERO) > 0,
                score.doubleValue());
    }

    private String resolveUserAnswer(ExamQuestion question, SubmitAnswerCommand answer) {
        if (answer == null) {
            return null;
        }
        if (answer.selectedOptionId() == null) {
            return answer.answerText();
        }
        return question.getOptions().stream()
                .filter(option -> option.getId().equals(answer.selectedOptionId()))
                .findFirst()
                .map(ExamQuestionOption::getContent)
                .orElse(answer.answerText());
    }
}
