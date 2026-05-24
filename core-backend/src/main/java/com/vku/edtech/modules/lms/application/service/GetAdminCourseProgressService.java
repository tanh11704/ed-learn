package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.dto.AdminCourseProgressResult;
import com.vku.edtech.modules.lms.application.port.in.GetAdminCourseProgressUseCase;
import com.vku.edtech.modules.lms.application.port.out.UserLearningQueryPort;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetAdminCourseProgressService implements GetAdminCourseProgressUseCase {

    private final UserLearningQueryPort userLearningQueryPort;

    @Override
    public List<AdminCourseProgressResult> getCourseProgressByCourseId(UUID courseId) {
        return userLearningQueryPort.findCourseProgressByCourseId(courseId);
    }
}
