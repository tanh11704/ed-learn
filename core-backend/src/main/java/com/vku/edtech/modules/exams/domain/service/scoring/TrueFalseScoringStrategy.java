package com.vku.edtech.modules.exams.domain.service.scoring;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;

public class TrueFalseScoringStrategy implements ExamScoringStrategy {

    @Override
    public boolean supports(ExamQuestion question, ExamQuestionScoringRule rule) {
        return question != null
                && rule != null
                && question.getQuestionType() == ExamQuestionType.TRUE_FALSE;
    }

    @Override
    public BigDecimal score(ExamQuestion question, ExamQuestionScoringRule rule, String userAnswer) {
        List<ExamQuestionOption> statements =
                question.getOptions().stream()
                        .sorted(Comparator.comparing(ExamQuestionOption::getOrderIndex))
                        .toList();

        List<Boolean> userValues = splitAnswers(userAnswer);
        int correctCount = 0;
        for (int i = 0; i < statements.size() && i < userValues.size(); i++) {
            Boolean userValue = userValues.get(i);
            if (userValue != null && statements.get(i).isCorrect() == userValue) {
                correctCount++;
            }
        }

        if (rule.paperPart() != ExamQuestionPaperPart.PART_II) {
            return correctCount == statements.size() && correctCount > 0
                    ? rule.scorePerQuestion()
                    : BigDecimal.ZERO;
        }

        return switch (correctCount) {
            case 4 -> rule.scorePerQuestion();
            case 3 -> BigDecimal.valueOf(0.5);
            case 2 -> BigDecimal.valueOf(0.25);
            case 1 -> BigDecimal.valueOf(0.1);
            default -> BigDecimal.ZERO;
        };
    }

    private List<Boolean> splitAnswers(String userAnswer) {
        if (userAnswer == null || userAnswer.isBlank()) {
            return List.of();
        }
        return List.of(userAnswer.split(",")).stream().map(this::parseBoolean).toList();
    }

    private Boolean parseBoolean(String value) {
        String normalized = value == null ? "" : value.trim().toLowerCase(Locale.ROOT);
        if (normalized.equals("true")
                || normalized.equals("t")
                || normalized.equals("1")
                || normalized.equals("d")
                || normalized.equals("đ")
                || normalized.equals("dung")
                || normalized.equals("đúng")) {
            return true;
        }
        if (normalized.equals("false")
                || normalized.equals("f")
                || normalized.equals("0")
                || normalized.equals("s")
                || normalized.equals("sai")) {
            return false;
        }
        return null;
    }
}
