package com.vku.edtech.modules.exams.domain.service.scoring;

import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamScoringResult;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

public class ExamScoringEngine {

    private final List<ExamScoringStrategy> strategies;

    public ExamScoringEngine(List<ExamScoringStrategy> strategies) {
        this.strategies = strategies;
    }

    public ExamScoringResult score(Exam exam, List<ExamQuestionScoringRule> rules, List<String> userAnswers) {
        BigDecimal total = BigDecimal.ZERO;
        BigDecimal max = BigDecimal.ZERO;

        for (int i = 0; i < exam.getQuestions().size(); i++) {
            ExamQuestion question = exam.getQuestions().get(i);
            ExamQuestionScoringRule rule = findRule(question, rules);
            String userAnswer = i < userAnswers.size() ? userAnswers.get(i) : null;
            BigDecimal score = scoreQuestion(question, rule, userAnswer);
            total = total.add(score);
            max = max.add(rule.scorePerQuestion());
        }

        return new ExamScoringResult(exam.getId(), total.setScale(2, RoundingMode.HALF_UP), max.setScale(2, RoundingMode.HALF_UP), "THPT_2026_PROFILE");
    }

    public BigDecimal scoreQuestion(ExamQuestion question, ExamQuestionScoringRule rule, String userAnswer) {
        if (question == null || rule == null) {
            return BigDecimal.ZERO;
        }
        return strategies.stream()
                .filter(strategy -> strategy.supports(question, rule))
                .findFirst()
                .map(strategy -> strategy.score(question, rule, userAnswer))
                .orElse(BigDecimal.ZERO);
    }

    private ExamQuestionScoringRule findRule(ExamQuestion question, List<ExamQuestionScoringRule> rules) {
        return rules.stream()
                .filter(rule ->
                        rule.questionType() == question.getQuestionType()
                                && rule.paperPart() == question.getPaperPart())
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Missing scoring rule for " + question.getQuestionType() + " " + question.getPaperPart()));
    }
}
