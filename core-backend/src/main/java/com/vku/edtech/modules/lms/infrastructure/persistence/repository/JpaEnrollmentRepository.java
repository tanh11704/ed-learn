package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.EnrollmentJpaEntity;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface JpaEnrollmentRepository extends JpaRepository<EnrollmentJpaEntity, UUID> {

    boolean existsByUserIdAndCourseId(UUID userId, UUID courseId);
}
