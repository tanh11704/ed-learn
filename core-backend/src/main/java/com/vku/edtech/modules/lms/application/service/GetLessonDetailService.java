package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetLessonDetailUseCase;
import com.vku.edtech.modules.lms.application.port.out.EnrollmentCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.shared.infrastructure.security.JwtUserInfo;
import com.vku.edtech.shared.presentation.exception.ForbiddenException;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetLessonDetailService implements GetLessonDetailUseCase {

    private final LessonQueryPort lessonQueryPort;
    private final EnrollmentCommandPort enrollmentCommandPort;

    @Override
    public Lesson getLessonDetail(GetLessonDetailQuery query) {
        Lesson lesson =
                lessonQueryPort
                        .findByIdAndNotDeleted(query.lessonId())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thây Lesson này"));

        if (!lesson.isPreview()) {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null
                    || !(authentication.getPrincipal() instanceof JwtUserInfo userInfo)) {
                throw new ForbiddenException("Bạn chưa có quyền truy cập bài học này");
            }

            var courseId =
                    lessonQueryPort
                            .findCourseIdByLessonId(query.lessonId())
                            .orElseThrow(
                                    () ->
                                            new ResourceNotFoundException(
                                                    "Không tìm thấy course của lesson"));
            boolean enrolled =
                    enrollmentCommandPort.existsByUserIdAndCourseId(userInfo.getId(), courseId);
            if (!enrolled) {
                throw new ForbiddenException("Bạn cần đăng ký khóa học để truy cập bài học này");
            }
        }

        return lesson;
    }
}
