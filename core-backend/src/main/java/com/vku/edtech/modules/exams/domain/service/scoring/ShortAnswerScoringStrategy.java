package com.vku.edtech.modules.exams.domain.service.scoring;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import java.math.BigDecimal;
import java.util.Locale;

public class ShortAnswerScoringStrategy implements ExamScoringStrategy {

    @Override
    public boolean supports(ExamQuestion question, ExamQuestionScoringRule rule) {
        return question != null
                && rule != null
                && question.getQuestionType() == ExamQuestionType.SHORT_ANSWER;
    }

    @Override
    public BigDecimal score(ExamQuestion question, ExamQuestionScoringRule rule, String userAnswer) {
        if (question.getCorrectAnswer() == null) {
            return BigDecimal.ZERO;
        }
        return normalize(question.getCorrectAnswer()).equals(normalize(userAnswer))
                ? rule.scorePerQuestion()
                : BigDecimal.ZERO;
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim().toLowerCase(Locale.ROOT);
    }
}
