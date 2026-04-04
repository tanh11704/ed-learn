package com.vku.edtech.modules.lms.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED, force = true)
@AllArgsConstructor
public class ErrorBankCard {
    private final UUID id;
    private final UUID userId;
    private String questionContent;
    private String wrongAnswer;
    private String correctAnswer;
    private int repetitionCount;
    private double easeFactor;
    private int intervalDays;
    private Instant nextReviewDate;
    private final Instant createdAt;
    private Instant updatedAt;

    public void review(int quality) {
        if (quality < 0 || quality > 5) {
            throw new InvalidDomainDataException("quality phải nằm trong khoảng từ 0 đến 5");
        }

        if (quality >= 3) {
            repetitionCount += 1;

            if (repetitionCount == 1) {
                intervalDays = 1;
            } else if (repetitionCount == 2) {
                intervalDays = 3;
            } else {
                intervalDays = Math.max(1, (int) Math.round(intervalDays * easeFactor));
            }

            easeFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
            if (easeFactor < 1.3) {
                easeFactor = 1.3;
            }
        } else {
            repetitionCount = 0;
            intervalDays = 1;
        }

        nextReviewDate = Instant.now().plus(intervalDays, ChronoUnit.DAYS);
        updatedAt = Instant.now();
    }
}
