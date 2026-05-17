package com.vku.edtech.modules.exams.domain.model;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public record ExamStructure(
        String profileCode,
        String subject,
        int durationMinutes,
        int partICount,
        int partIICount,
        int partIIICount,
        BigDecimal maxScore,
        List<ExamQuestionScoringRule> rules) {

    public static ExamStructure thpt2026(String subject) {
        return Thpt2026ExamProfile.structureFor(subject);
    }

    public int totalQuestions() {
        return partICount + partIICount + partIIICount;
    }

    public int expectedCount(ExamQuestionPaperPart part) {
        return switch (part) {
            case PART_I -> partICount;
            case PART_II -> partIICount;
            case PART_III -> partIIICount;
        };
    }

    public Optional<ExamQuestionScoringRule> findRule(
            ExamQuestionType questionType, ExamQuestionPaperPart paperPart) {
        return rules.stream()
                .filter(rule ->
                        rule.questionType() == questionType && rule.paperPart() == paperPart)
                .findFirst();
    }
}
