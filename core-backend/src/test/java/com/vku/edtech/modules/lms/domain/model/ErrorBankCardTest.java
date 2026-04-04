package com.vku.edtech.modules.lms.domain.model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class ErrorBankCardTest {

    @Test
    void review_WhenQualityOutOfRange_ShouldThrowException() {
        ErrorBankCard card = buildCard(0, 2.5, 1);

        assertThrows(InvalidDomainDataException.class, () -> card.review(-1));
        assertThrows(InvalidDomainDataException.class, () -> card.review(6));
    }

    @Test
    void review_WhenRememberedAndFirstRepetition_ShouldSetIntervalToOneAndIncreaseEaseFactor() {
        ErrorBankCard card = buildCard(0, 2.5, 1);
        Instant before = Instant.now();

        card.review(5);

        assertEquals(1, card.getRepetitionCount());
        assertEquals(1, card.getIntervalDays());
        assertEquals(2.6, card.getEaseFactor(), 0.0001);
        assertTrue(!card.getNextReviewDate().isBefore(before.plus(1, ChronoUnit.DAYS)));
    }

    @Test
    void review_WhenRememberedAndSecondRepetition_ShouldSetIntervalToThreeDays() {
        ErrorBankCard card = buildCard(1, 2.5, 1);

        card.review(4);

        assertEquals(2, card.getRepetitionCount());
        assertEquals(3, card.getIntervalDays());
        assertEquals(2.5, card.getEaseFactor(), 0.0001);
    }

    @Test
    void review_WhenRememberedAndThirdPlusRepetition_ShouldMultiplyByEaseFactor() {
        ErrorBankCard card = buildCard(2, 2.5, 3);

        card.review(4);

        assertEquals(3, card.getRepetitionCount());
        assertEquals(8, card.getIntervalDays());
        assertEquals(2.5, card.getEaseFactor(), 0.0001);
    }

    @Test
    void review_WhenForgot_ShouldResetRepetitionAndInterval() {
        ErrorBankCard card = buildCard(4, 2.5, 20);

        card.review(2);

        assertEquals(0, card.getRepetitionCount());
        assertEquals(1, card.getIntervalDays());
        assertEquals(2.5, card.getEaseFactor(), 0.0001);
        assertTrue(card.getNextReviewDate().isAfter(Instant.now().plus(23, ChronoUnit.HOURS)));
    }

    @Test
    void review_WhenEaseFactorWouldDropBelowMinimum_ShouldClampToOnePointThree() {
        ErrorBankCard card = buildCard(2, 1.31, 3);

        card.review(3);

        assertEquals(1.3, card.getEaseFactor(), 0.0001);
    }

    private ErrorBankCard buildCard(int repetitionCount, double easeFactor, int intervalDays) {
        Instant now = Instant.now();
        return ErrorBankCard.builder()
                .id(UUID.randomUUID())
                .userId(UUID.randomUUID())
                .questionContent("Question")
                .wrongAnswer("A")
                .correctAnswer("B")
                .repetitionCount(repetitionCount)
                .easeFactor(easeFactor)
                .intervalDays(intervalDays)
                .nextReviewDate(now)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }
}
