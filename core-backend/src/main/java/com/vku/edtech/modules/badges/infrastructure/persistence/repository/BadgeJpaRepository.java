package com.vku.edtech.modules.badges.infrastructure.persistence.repository;

import com.vku.edtech.modules.badges.domain.model.BadgeCategory;
import com.vku.edtech.modules.badges.infrastructure.persistence.entity.BadgeJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface BadgeJpaRepository extends JpaRepository<BadgeJpaEntity, UUID> {
    Optional<BadgeJpaEntity> findByCode(String code);

    boolean existsByCode(String code);

    List<BadgeJpaEntity> findAllByCategory(BadgeCategory category);
}
