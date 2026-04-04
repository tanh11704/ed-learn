package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.UserCourseProgressJpaEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserCourseProgressJpaRepository
        extends JpaRepository<UserCourseProgressJpaEntity, UUID> {
    Optional<UserCourseProgressJpaEntity> findByUserIdAndCourseId(UUID userId, UUID courseId);
}
