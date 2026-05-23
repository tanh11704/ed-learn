package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.application.dto.AdminCourseProgressResult;
import java.util.List;

public interface GetAdminCourseProgressUseCase {
    List<AdminCourseProgressResult> getCourseProgress();
}
