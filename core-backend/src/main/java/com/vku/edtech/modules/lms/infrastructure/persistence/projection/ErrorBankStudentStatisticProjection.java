package com.vku.edtech.modules.lms.infrastructure.persistence.projection;

import java.time.Instant;
import java.util.UUID;

public interface ErrorBankStudentStatisticProjection {
    UUID getStudentId();

    String getStudentName();

    String getEmail();

    Integer getGradeLevel();

    String getClassName();

    Long getTotalErrors();

    Long getDueErrors();

    Long getReviewedErrors();

    Long getMasteredErrors();

    Double getAverageEaseFactor();

    Double getAverageIntervalDays();

    Instant getNextReviewDate();

    Instant getLastUpdatedAt();
}
