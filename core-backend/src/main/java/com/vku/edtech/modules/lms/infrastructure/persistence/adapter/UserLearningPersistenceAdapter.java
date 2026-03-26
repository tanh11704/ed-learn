package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.dto.EnrolledCourseResult;
import com.vku.edtech.modules.lms.application.port.out.UserLearningQueryPort;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.JpaEnrollmentRepository;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserLearningPersistenceAdapter implements UserLearningQueryPort {

    private final JpaEnrollmentRepository enrollmentRepository;

    @Override
    public List<EnrolledCourseResult> findEnrolledCoursesByUserId(UUID userId) {
        return enrollmentRepository.findEnrolledCoursesByUserId(userId).stream()
                .map(
                        projection ->
                                new EnrolledCourseResult(
                                        projection.getCourseId(),
                                        projection.getTitle(),
                                        projection.getThumbnailUrl(),
                                        projection.getEnrolledDate()))
                .collect(Collectors.toList());
    }
}
