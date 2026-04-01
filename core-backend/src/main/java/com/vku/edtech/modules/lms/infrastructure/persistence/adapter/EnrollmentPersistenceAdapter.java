package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.port.out.EnrollmentCommandPort;
import com.vku.edtech.modules.lms.domain.model.Enrollment;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.EnrollmentJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.EnrollmentMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.JpaEnrollmentRepository;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class EnrollmentPersistenceAdapter implements EnrollmentCommandPort {

    private final JpaEnrollmentRepository enrollmentRepository;
    private final EnrollmentMapper enrollmentMapper;

    @Override
    public Enrollment save(Enrollment enrollment) {
        EnrollmentJpaEntity entity = enrollmentMapper.toEntity(enrollment);
        EnrollmentJpaEntity savedEntity = enrollmentRepository.save(entity);
        return enrollmentMapper.toDomain(savedEntity);
    }

    @Override
    public boolean existsByUserIdAndCourseId(UUID userId, UUID courseId) {
        return enrollmentRepository.existsByUserIdAndCourseId(userId, courseId);
    }
}
