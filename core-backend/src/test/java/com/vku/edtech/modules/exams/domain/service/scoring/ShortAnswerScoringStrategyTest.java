package com.vku.edtech.modules.exams.domain.service.scoring;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class ShortAnswerScoringStrategyTest {

    private final ShortAnswerScoringStrategy strategy = new ShortAnswerScoringStrategy();

    @Test
    void score_should_return_full_score_when_answer_matches() {
        ExamQuestion question = buildQuestion();
        ExamQuestionScoringRule rule = rule();

        BigDecimal score = strategy.score(question, rule, "Hanoi");

        assertEquals(BigDecimal.ONE, score);
    }

    @Test
    void score_should_return_zero_when_answer_differs() {
        ExamQuestion question = buildQuestion();
        ExamQuestionScoringRule rule = rule();

        BigDecimal score = strategy.score(question, rule, "Hue");

        assertEquals(BigDecimal.ZERO, score);
    }

    private ExamQuestion buildQuestion() {
        return ExamQuestion.builder()
                .id(UUID.randomUUID())
                .examId(UUID.randomUUID())
                .questionType(ExamQuestionType.SHORT_ANSWER)
                .paperPart(ExamQuestionPaperPart.PART_III)
                .content("Thủ đô Việt Nam là gì?")
                .correctAnswer("Hanoi")
                .score(1.0)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }

    private ExamQuestionScoringRule rule() {
        return new ExamQuestionScoringRule(
                ExamQuestionType.SHORT_ANSWER,
                ExamQuestionPaperPart.PART_III,
                BigDecimal.ONE,
                1);
    }
}
