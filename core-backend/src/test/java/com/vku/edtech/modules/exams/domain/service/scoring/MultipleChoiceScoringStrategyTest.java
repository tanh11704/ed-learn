package com.vku.edtech.modules.exams.domain.service.scoring;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class MultipleChoiceScoringStrategyTest {

    private final MultipleChoiceScoringStrategy strategy = new MultipleChoiceScoringStrategy();

    @Test
    void score_should_return_full_score_for_correct_answer() {
        ExamQuestion question = buildQuestion();
        ExamQuestionScoringRule rule = rule();

        BigDecimal score = strategy.score(question, rule, "A");

        assertEquals(new BigDecimal("0.25"), score);
    }

    @Test
    void score_should_return_zero_for_wrong_answer() {
        ExamQuestion question = buildQuestion();
        ExamQuestionScoringRule rule = rule();

        BigDecimal score = strategy.score(question, rule, "B");

        assertEquals(BigDecimal.ZERO, score);
    }

    private ExamQuestion buildQuestion() {
        return ExamQuestion.builder()
                .id(UUID.randomUUID())
                .examId(UUID.randomUUID())
                .questionType(ExamQuestionType.MULTIPLE_CHOICE)
                .paperPart(ExamQuestionPaperPart.PART_I)
                .content("Test")
                .score(0.25)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .options(
                        List.of(
                                ExamQuestionOption.createNew(UUID.randomUUID(), "A", true, 1),
                                ExamQuestionOption.createNew(UUID.randomUUID(), "B", false, 2)))
                .build();
    }

    private ExamQuestionScoringRule rule() {
        return new ExamQuestionScoringRule(
                ExamQuestionType.MULTIPLE_CHOICE,
                ExamQuestionPaperPart.PART_I,
                BigDecimal.valueOf(0.25),
                1);
    }
}
