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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class TrueFalseScoringStrategyTest {

    private TrueFalseScoringStrategy strategy;

    @BeforeEach
    void setUp() {
        strategy = new TrueFalseScoringStrategy();
    }

    @Test
    void score_should_return_01_for_one_correct() {
        ExamQuestion question = buildQuestion();
        ExamQuestionScoringRule rule = rule();

        BigDecimal score = strategy.score(question, rule, "true,false,false,false");

        assertEquals(new BigDecimal("0.1"), score);
    }

    @Test
    void score_should_return_025_for_two_correct() {
        ExamQuestion question = buildQuestion();
        ExamQuestionScoringRule rule = rule();

        BigDecimal score = strategy.score(question, rule, "true,true,false,false");

        assertEquals(new BigDecimal("0.25"), score);
    }

    @Test
    void score_should_return_05_for_three_correct() {
        ExamQuestion question = buildQuestion();
        ExamQuestionScoringRule rule = rule();

        BigDecimal score = strategy.score(question, rule, "true,true,true,false");

        assertEquals(new BigDecimal("0.5"), score);
    }

    @Test
    void score_should_return_1_for_four_correct() {
        ExamQuestion question = buildQuestion();
        ExamQuestionScoringRule rule = rule();

        BigDecimal score = strategy.score(question, rule, "true,true,true,true");

        assertEquals(BigDecimal.ONE, score);
    }

    private ExamQuestion buildQuestion() {
        return ExamQuestion.builder()
                .id(UUID.randomUUID())
                .examId(UUID.randomUUID())
                .questionType(ExamQuestionType.TRUE_FALSE)
                .paperPart(ExamQuestionPaperPart.PART_II)
                .content("Test")
                .score(1.0)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .options(
                        List.of(
                                ExamQuestionOption.createNew(UUID.randomUUID(), "A", true, 1),
                                ExamQuestionOption.createNew(UUID.randomUUID(), "B", true, 2),
                                ExamQuestionOption.createNew(UUID.randomUUID(), "C", true, 3),
                                ExamQuestionOption.createNew(UUID.randomUUID(), "D", true, 4)))
                .build();
    }

    private ExamQuestionScoringRule rule() {
        return new ExamQuestionScoringRule(
                ExamQuestionType.TRUE_FALSE,
                ExamQuestionPaperPart.PART_II,
                BigDecimal.ONE,
                4);
    }
}
