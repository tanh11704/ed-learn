package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.application.dto.AdminCourseProgressResult;
import java.util.List;
import java.util.UUID;

public interface GetAdminCourseProgressUseCase {
    List<AdminCourseProgressResult> getCourseProgressByCourseId(UUID courseId);
}
