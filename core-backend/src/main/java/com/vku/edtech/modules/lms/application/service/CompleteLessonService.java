package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.event.LessonCompletedEvent;
import com.vku.edtech.modules.lms.application.port.in.CompleteLessonUseCase;
import com.vku.edtech.modules.lms.application.port.out.EnrollmentCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.application.port.out.UserCourseProgressCommandPort;
import com.vku.edtech.modules.lms.application.port.out.UserCourseProgressQueryPort;
import com.vku.edtech.modules.lms.application.port.out.UserProgressLessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.UserProgressLessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.UserCourseProgress;
import com.vku.edtech.modules.lms.domain.model.UserProgressLesson;
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
    private final EnrollmentCommandPort enrollmentCommandPort;
    private final UserProgressLessonQueryPort userProgressLessonQueryPort;
    private final UserProgressLessonCommandPort userProgressLessonCommandPort;
    private final UserCourseProgressQueryPort userCourseProgressQueryPort;
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
                enrollmentCommandPort.existsByUserIdAndCourseId(command.userId(), courseId);
        if (!enrolled) {
            throw new ForbiddenException("Bạn chưa đăng ký khóa học này");
        }

        var existingProgress =
                userProgressLessonQueryPort.findByUserIdAndLessonId(
                        command.userId(), command.lessonId());

        if (existingProgress.isPresent() && existingProgress.get().isCompleted()) {
            return;
        }

        UserProgressLesson progressLesson =
                existingProgress.orElseGet(
                        () ->
                                UserProgressLesson.createInProgress(
                                        command.userId(), command.lessonId()));
        progressLesson.markCompleted();
        userProgressLessonCommandPort.save(progressLesson);

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

        UserCourseProgress userCourseProgress =
                userCourseProgressQueryPort
                        .findByUserIdAndCourseId(command.userId(), courseId)
                        .orElseGet(() -> UserCourseProgress.create(command.userId(), courseId));

        userCourseProgress.updateProgress(percent, lesson.getId());
        userCourseProgressCommandPort.save(userCourseProgress);

        eventPublisher.publishEvent(
                new LessonCompletedEvent(
                        command.userId(), command.lessonId(), courseId, java.time.Instant.now()));
    }
}
