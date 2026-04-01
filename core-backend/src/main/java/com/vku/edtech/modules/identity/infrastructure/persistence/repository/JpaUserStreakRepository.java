package com.vku.edtech.modules.identity.infrastructure.persistence.repository;

import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserStreakJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface JpaUserStreakRepository extends JpaRepository<UserStreakJpaEntity, UUID> {
    Optional<UserStreakJpaEntity> findByUserId(UUID userId);
}
