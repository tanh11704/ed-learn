package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record ErrorBankCardResponse(
        UUID id,
        String questionContent,
        String wrongAnswer,
        String correctAnswer,
        int repetitionCount,
        double easeFactor,
        int intervalDays,
        Instant nextReviewDate) {}
