package com.vku.edtech.modules.lms.infrastructure.persistence.projection;

import java.util.UUID;

public interface TopCourseProjection {
    UUID getCourseId();

    String getTitle();

    Long getTotalStudents();
}
