package com.vku.edtech.modules.exams.infrastructure.persistence.projection;

public interface ExamAttemptsByGradeProjection {
    Integer getGradeLevel();

    Long getAttemptCount();

    Long getSubmittedCount();

    Double getAverageScore();
}
