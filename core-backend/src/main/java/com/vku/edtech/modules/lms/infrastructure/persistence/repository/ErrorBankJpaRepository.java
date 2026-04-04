package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ErrorBankJpaEntity;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ErrorBankJpaRepository extends JpaRepository<ErrorBankJpaEntity, UUID> {
    List<ErrorBankJpaEntity> findByUserIdAndNextReviewDateLessThanEqualOrderByNextReviewDateAsc(
            UUID userId, Instant now);

    Optional<ErrorBankJpaEntity> findByIdAndUserId(UUID id, UUID userId);
}
