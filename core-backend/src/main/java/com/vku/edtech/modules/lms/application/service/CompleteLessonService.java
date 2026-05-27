package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.event.LessonCompletedEvent;
import com.vku.edtech.modules.lms.application.port.in.CompleteLessonUseCase;
import com.vku.edtech.modules.lms.application.port.out.EnrollmentQueryPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.application.port.out.UserCourseProgressCommandPort;
import com.vku.edtech.modules.lms.application.port.out.UserProgressLessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.UserProgressLessonQueryPort;
import com.vku.edtech.shared.presentation.exception.ForbiddenException;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CompleteLessonService implements CompleteLessonUseCase {

    private final LessonQueryPort lessonQueryPort;
    private final EnrollmentQueryPort enrollmentQueryPort;
    private final UserProgressLessonQueryPort userProgressLessonQueryPort;
    private final UserProgressLessonCommandPort userProgressLessonCommandPort;
    private final UserCourseProgressCommandPort userCourseProgressCommandPort;
    private final ApplicationEventPublisher eventPublisher;

    @Override
    @Transactional
    public void complete(CompleteLessonCommand command) {
        var lesson =
                lessonQueryPort
                        .findByIdAndNotDeleted(command.lessonId())
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy lesson"));

        var courseId =
                lessonQueryPort
                        .findCourseIdByLessonId(command.lessonId())
                        .orElseThrow(
                                () ->
                                        new ResourceNotFoundException(
                                                "Không tìm thấy course của lesson"));

        boolean enrolled =
                enrollmentQueryPort.existsByUserIdAndCourseId(command.userId(), courseId);
        if (!enrolled) {
            throw new ForbiddenException("Bạn chưa đăng ký khóa học này");
        }

        boolean newlyCompleted =
                userProgressLessonCommandPort.markCompleted(command.userId(), command.lessonId());
        if (!newlyCompleted) {
            return;
        }

        long totalLessons = lessonQueryPort.countLessonsByCourseId(courseId);
        long completedLessons =
                userProgressLessonQueryPort.countCompletedByUserIdAndCourseId(
                        command.userId(), courseId);

        int percent =
                totalLessons == 0
                        ? 0
                        : (int)
                                Math.min(
                                        100, Math.round((completedLessons * 100.0) / totalLessons));

        userCourseProgressCommandPort.upsertProgress(
                command.userId(), courseId, percent, lesson.getId());

        eventPublisher.publishEvent(
                new LessonCompletedEvent(
                        command.userId(), command.lessonId(), courseId, java.time.Instant.now()));
    }
}
