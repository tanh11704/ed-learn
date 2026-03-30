package com.vku.edtech.modules.badges.infrastructure.persistence.repository;

import com.vku.edtech.modules.badges.infrastructure.persistence.entity.UserBadgeJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserBadgeJpaRepository extends JpaRepository<UserBadgeJpaEntity, UUID> {

    @Query("SELECT ub FROM UserBadgeJpaEntity ub JOIN FETCH ub.badge WHERE ub.user.id = :userId")
    List<UserBadgeJpaEntity> findAllByUserIdWithBadge(@Param("userId") UUID userId);

    @Query("SELECT ub FROM UserBadgeJpaEntity ub JOIN FETCH ub.badge WHERE ub.id = :id")
    Optional<UserBadgeJpaEntity> findByIdWithBadge(@Param("id") UUID id);

    List<UserBadgeJpaEntity> findAllByUser_Id(UUID userId);

    Optional<UserBadgeJpaEntity> findByUser_IdAndBadge_Id(UUID userId, UUID badgeId);

    boolean existsByUser_IdAndBadge_Id(UUID userId, UUID badgeId);
}
