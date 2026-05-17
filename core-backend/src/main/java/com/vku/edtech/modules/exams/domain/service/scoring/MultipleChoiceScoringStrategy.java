package com.vku.edtech.modules.exams.domain.service.scoring;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import java.math.BigDecimal;
import java.util.Set;
import java.util.stream.Collectors;

public class MultipleChoiceScoringStrategy implements ExamScoringStrategy {

    @Override
    public boolean supports(ExamQuestion question, ExamQuestionScoringRule rule) {
        return question != null
                && rule != null
                && question.getQuestionType() == ExamQuestionType.MULTIPLE_CHOICE;
    }

    @Override
    public BigDecimal score(ExamQuestion question, ExamQuestionScoringRule rule, String userAnswer) {
        Set<String> correctAnswers =
                question.getOptions().stream()
                        .filter(ExamQuestionOption::isCorrect)
                        .map(option -> normalize(option.getContent()))
                        .collect(Collectors.toSet());

        if (rule.paperPart() == ExamQuestionPaperPart.PART_I) {
            return correctAnswers.size() == 1 && correctAnswers.contains(normalize(userAnswer))
                    ? rule.scorePerQuestion()
                    : BigDecimal.ZERO;
        }

        return correctAnswers.contains(normalize(userAnswer)) ? rule.scorePerQuestion() : BigDecimal.ZERO;
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim().toLowerCase();
    }
}
