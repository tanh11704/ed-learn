package com.vku.edtech.modules.identity.infrastructure.persistence.repository;

import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserStreakJpaEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JpaUserStreakRepository extends JpaRepository<UserStreakJpaEntity, UUID> {
    Optional<UserStreakJpaEntity> findByUserId(UUID userId);
}
