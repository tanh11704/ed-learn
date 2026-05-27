package com.vku.edtech.modules.exams.domain.service;

import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import com.vku.edtech.modules.exams.domain.model.ExamScoringResult;
import com.vku.edtech.modules.exams.domain.model.ExamStructure;
import com.vku.edtech.modules.exams.domain.model.Thpt2026ExamProfile;
import com.vku.edtech.modules.exams.domain.service.scoring.ExamScoringStrategy;
import com.vku.edtech.modules.exams.domain.service.scoring.MultipleChoiceScoringStrategy;
import com.vku.edtech.modules.exams.domain.service.scoring.ShortAnswerScoringStrategy;
import com.vku.edtech.modules.exams.domain.service.scoring.TrueFalseScoringStrategy;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

public class ExamScoringEngine {

    private final List<ExamScoringStrategy> strategies =
            List.of(
                    new MultipleChoiceScoringStrategy(),
                    new TrueFalseScoringStrategy(),
                    new ShortAnswerScoringStrategy());

    public ExamScoringResult score(Exam exam, List<QuestionAnswer> answers, ExamStructure structure) {
        ExamStructure scoringStructure = resolveStructure(exam, structure);
        BigDecimal total = BigDecimal.ZERO;
        BigDecimal max = BigDecimal.ZERO;

        for (ExamQuestion question : exam.getQuestions()) {
            ExamQuestionScoringRule rule = findRule(scoringStructure, question);
            BigDecimal ruleScore = rule == null ? BigDecimal.ZERO : rule.scorePerQuestion();
            max = max.add(ruleScore);
            String userAnswer = findAnswer(answers, question.getId());
            total = total.add(scoreQuestion(question, rule, userAnswer));
        }

        return new ExamScoringResult(
                exam.getId(),
                total.setScale(2, RoundingMode.HALF_UP),
                max.setScale(2, RoundingMode.HALF_UP),
                scoringStructure == null ? "CUSTOM" : scoringStructure.profileCode());
    }

    public ExamScoringResult score(Exam exam, List<QuestionAnswer> answers) {
        return score(exam, answers, null);
    }

    public BigDecimal scoreQuestion(
            ExamQuestion question, ExamQuestionScoringRule rule, String userAnswer) {
        if (question == null || rule == null) return BigDecimal.ZERO;

        for (ExamScoringStrategy strategy : strategies) {
            if (strategy.supports(question, rule)) {
                return strategy.score(question, rule, userAnswer);
            }
        }
        return BigDecimal.ZERO;
    }

    private ExamQuestionScoringRule findRule(ExamStructure structure, ExamQuestion question) {
        if (structure == null || structure.rules() == null) return null;
        return structure.findRule(question.getQuestionType(), question.getPaperPart()).orElse(null);
    }

    private ExamStructure resolveStructure(Exam exam, ExamStructure structure) {
        if (structure != null) {
            return structure;
        }
        if (exam != null && Thpt2026ExamProfile.supports(exam.getSubject())) {
            return ExamStructure.thpt2026(exam.getSubject());
        }
        return null;
    }

    private String findAnswer(List<QuestionAnswer> answers, java.util.UUID questionId) {
        if (answers == null || questionId == null) return null;
        for (QuestionAnswer answer : answers) {
            if (answer != null && questionId.equals(answer.questionId())) {
                return answer.answer();
            }
        }
        return null;
    }

    public record QuestionAnswer(java.util.UUID questionId, String answer) {}
}
