package com.vku.edtech.modules.exams.infrastructure.persistence.projection;

import java.time.Instant;
import java.util.UUID;

public interface ExamAttemptStudentProjection {
    UUID getAttemptId();

    UUID getExamId();

    UUID getStudentId();

    String getStudentName();

    String getEmail();

    Integer getGradeLevel();

    String getClassName();

    String getStatus();

    Instant getStartedAt();

    Instant getSubmittedAt();

    Integer getDurationSeconds();

    Double getScore();

    Double getMaxScore();
}
