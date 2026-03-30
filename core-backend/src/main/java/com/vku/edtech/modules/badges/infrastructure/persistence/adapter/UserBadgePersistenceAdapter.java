package com.vku.edtech.modules.badges.infrastructure.persistence.adapter;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Component;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;
import com.vku.edtech.modules.badges.application.port.out.UserBadgeCommandPort;
import com.vku.edtech.modules.badges.application.port.out.UserBadgeQueryPort;
import com.vku.edtech.modules.badges.domain.model.UserBadge;
import com.vku.edtech.modules.badges.infrastructure.persistence.entity.BadgeJpaEntity;
import com.vku.edtech.modules.badges.infrastructure.persistence.entity.UserBadgeJpaEntity;
import com.vku.edtech.modules.badges.infrastructure.persistence.mapper.UserBadgeMapper;
import com.vku.edtech.modules.badges.infrastructure.persistence.repository.UserBadgeJpaRepository;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;

import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class UserBadgePersistenceAdapter implements UserBadgeQueryPort, UserBadgeCommandPort {

  private final UserBadgeJpaRepository userBadgeJpaRepository;
  private final UserBadgeMapper userBadgeMapper;
  private final EntityManager entityManager;

  @Override
  public UserBadge save(UserBadge userBadge) {
    UserJpaEntity userRef = entityManager.getReference(UserJpaEntity.class, userBadge.getUserId());
    BadgeJpaEntity badRef = entityManager.getReference(BadgeJpaEntity.class, userBadge.getBadgeId());

    UserBadgeJpaEntity entity = UserBadgeJpaEntity.builder()
        .id(userBadge.getId())
        .user(userRef)
        .badge(badRef)
        .earnedAt(userBadge.getEarnedAt())
        .isNew(userBadge.getIsNew())
        .build();

    return userBadgeMapper.toDomain(userBadgeJpaRepository.save(entity));
  }

  @Override
  public List<UserBadgeResult> findMyBadges(UUID userId) {
    return userBadgeJpaRepository.findAllByUser_Id(userId)
        .stream()
        .map(this::toResult)
        .toList();
  }

  @Override
  public Optional<UserBadge> findByIdAndUserId(UUID userBadgeId, UUID userId) {
    return userBadgeJpaRepository.findByIdAndUser_Id(userBadgeId, userId)
        .map(userBadgeMapper::toDomain);
  }

  @Override
  public boolean existsByUserIdAndBadgeId(UUID userId, UUID badgeId) {
    return userBadgeJpaRepository.existsByUser_IdAndBadge_Id(userId, badgeId);
  }

  private UserBadgeResult toResult(UserBadgeJpaEntity entity) {
    return new UserBadgeResult(
        entity.getId(),
        entity.getBadge().getId(),
        entity.getBadge().getCode(),
        entity.getBadge().getName(),
        entity.getBadge().getDescription(),
        entity.getBadge().getCategory(),
        entity.getBadge().getImageUrl(),
        entity.getBadge().getXpReward(),
        entity.getEarnedAt(),
        entity.getIsNew());
  }
}
