package com.vku.edtech.modules.exams.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Duration;
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
public class ExamAttempt {
    private final UUID id;
    private final UUID examId;
    private final UUID userId;
    private final Integer gradeLevel;
    private final String className;
    private ExamAttemptStatus status;
    private final Instant startedAt;
    private Instant submittedAt;
    private Integer durationSeconds;
    private Double score;
    private Double maxScore;
    private final Instant createdAt;
    private Instant updatedAt;

    public static ExamAttempt start(UUID examId, UUID userId, Integer gradeLevel, String className) {
        if (examId == null) {
            throw new InvalidDomainDataException("Exam ID khong hop le");
        }
        if (userId == null) {
            throw new InvalidDomainDataException("User ID khong hop le");
        }
        if (gradeLevel == null || gradeLevel < 1 || gradeLevel > 12) {
            throw new InvalidDomainDataException("Lop khong hop le");
        }

        Instant now = Instant.now();
        return ExamAttempt.builder()
                .examId(examId)
                .userId(userId)
                .gradeLevel(gradeLevel)
                .className(className == null || className.isBlank() ? null : className.trim())
                .status(ExamAttemptStatus.IN_PROGRESS)
                .startedAt(now)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }

    public void submit(Double score, Double maxScore) {
        if (status != ExamAttemptStatus.IN_PROGRESS) {
            throw new InvalidDomainDataException("Luot lam de khong con o trang thai dang lam");
        }
        Instant now = Instant.now();
        this.status = ExamAttemptStatus.SUBMITTED;
        this.submittedAt = now;
        this.durationSeconds = (int) Duration.between(startedAt, now).getSeconds();
        this.score = score;
        this.maxScore = maxScore;
        this.updatedAt = now;
    }
}
