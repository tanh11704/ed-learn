package com.vku.edtech.modules.exams.infrastructure.persistence.projection;

import java.util.UUID;

public interface ExamAttemptSummaryProjection {
    UUID getExamId();

    String getExamTitle();

    Long getAttemptCount();

    Long getSubmittedCount();

    Double getAverageScore();

    Double getHighestScore();

    Double getLowestScore();
}
