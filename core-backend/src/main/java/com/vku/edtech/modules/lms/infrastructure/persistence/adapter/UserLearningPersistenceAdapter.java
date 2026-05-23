package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.dto.AdminCourseProgressResult;
import com.vku.edtech.modules.lms.application.dto.EnrolledCourseResult;
import com.vku.edtech.modules.lms.application.port.out.UserLearningQueryPort;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.UserLearningJpaRepository;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserLearningPersistenceAdapter implements UserLearningQueryPort {

    private final UserLearningJpaRepository userLearningRepository;

    @Override
    public List<EnrolledCourseResult> findEnrolledCoursesByUserId(UUID userId) {
        return userLearningRepository.findEnrolledCoursesByUserId(userId).stream()
                .map(
                        projection ->
                                new EnrolledCourseResult(
                                        projection.getCourseId(),
                                        projection.getTitle(),
                                        projection.getThumbnailUrl(),
                                        projection.getEnrolledDate(),
                                        projection.getProgressPercent(),
                                        projection.getCompletedLessons(),
                                        projection.getTotalLessons(),
                                        projection.getLastAccessedLessonId()))
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminCourseProgressResult> findCourseProgressByCourseId(UUID courseId) {
        return userLearningRepository.findCourseProgressByCourseId(courseId).stream()
                .map(
                        projection ->
                                new AdminCourseProgressResult(
                                        projection.getEnrollmentId(),
                                        projection.getStudentId(),
                                        projection.getStudentName(),
                                        projection.getEmail(),
                                        projection.getCourseId(),
                                        projection.getCourseTitle(),
                                        projection.getEnrolledAt(),
                                        projection.getProgressPercent() != null
                                                ? projection.getProgressPercent()
                                                : 0,
                                        projection.getCompletedLessons() != null
                                                ? projection.getCompletedLessons()
                                                : 0,
                                        projection.getTotalLessons() != null
                                                ? projection.getTotalLessons()
                                                : 0,
                                        projection.getLastActivity(),
                                        projection.getStatus()))
                .collect(Collectors.toList());
    }
}
