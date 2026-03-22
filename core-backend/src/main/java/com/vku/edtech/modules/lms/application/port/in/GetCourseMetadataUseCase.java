package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Course;
import java.util.UUID;

public interface GetCourseMetadataUseCase {
    Course getCourseWithChapters(GetCourseMetadataQuery query);

    record GetCourseMetadataQuery(UUID courseId) {}
}
