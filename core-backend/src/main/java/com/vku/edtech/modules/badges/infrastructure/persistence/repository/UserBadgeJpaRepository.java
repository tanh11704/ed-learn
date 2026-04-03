package com.vku.edtech.modules.badges.infrastructure.persistence.repository;

import com.vku.edtech.modules.badges.infrastructure.persistence.entity.UserBadgeJpaEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserBadgeJpaRepository extends JpaRepository<UserBadgeJpaEntity, UUID> {

    @Query(
            value =
                    "SELECT ub FROM UserBadgeJpaEntity ub JOIN FETCH ub.badge WHERE ub.user.id = :userId",
            countQuery = "SELECT COUNT(ub) FROM UserBadgeJpaEntity ub WHERE ub.user.id = :userId")
    Page<UserBadgeJpaEntity> findAllByUserIdWithBadge(
            @Param("userId") UUID userId, Pageable pageable);

    @Query("SELECT ub FROM UserBadgeJpaEntity ub JOIN FETCH ub.badge WHERE ub.id = :id")
    Optional<UserBadgeJpaEntity> findByIdWithBadge(@Param("id") UUID id);

    Optional<UserBadgeJpaEntity> findByUser_IdAndBadge_Id(UUID userId, UUID badgeId);

    Optional<UserBadgeJpaEntity> findByIdAndUser_Id(UUID userBadgeId, UUID userId);

    boolean existsByUser_IdAndBadge_Id(UUID userId, UUID badgeId);
}
