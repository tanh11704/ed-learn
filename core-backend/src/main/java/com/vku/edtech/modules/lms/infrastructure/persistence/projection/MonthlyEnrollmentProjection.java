package com.vku.edtech.modules.lms.infrastructure.persistence.projection;

public interface MonthlyEnrollmentProjection {
    Integer getMonth();

    Integer getYear();

    Long getEnrollments();
}
