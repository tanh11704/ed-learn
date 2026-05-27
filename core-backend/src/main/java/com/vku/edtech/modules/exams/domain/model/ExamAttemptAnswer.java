package com.vku.edtech.modules.exams.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
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
public class ExamAttemptAnswer {
    private final UUID id;
    private final UUID attemptId;
    private final UUID questionId;
    private final UUID selectedOptionId;
    private final String answerText;
    private final Boolean correct;
    private final Double score;
    private final Instant createdAt;
    private final Instant updatedAt;

    public static ExamAttemptAnswer create(
            UUID attemptId,
            UUID questionId,
            UUID selectedOptionId,
            String answerText,
            Boolean correct,
            Double score) {
        if (attemptId == null) {
            throw new InvalidDomainDataException("Attempt ID khong hop le");
        }
        if (questionId == null) {
            throw new InvalidDomainDataException("Question ID khong hop le");
        }

        Instant now = Instant.now();
        return ExamAttemptAnswer.builder()
                .attemptId(attemptId)
                .questionId(questionId)
                .selectedOptionId(selectedOptionId)
                .answerText(answerText == null || answerText.isBlank() ? null : answerText.trim())
                .correct(correct)
                .score(score)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }
}
