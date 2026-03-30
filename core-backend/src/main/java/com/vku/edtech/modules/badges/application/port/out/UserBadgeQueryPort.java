package com.vku.edtech.modules.badges.application.port.out;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;
import com.vku.edtech.modules.badges.domain.model.UserBadge;

public interface UserBadgeQueryPort {
  List<UserBadgeResult> findMyBadges(UUID userId);

  Optional<UserBadge> findByIdAndUserId(UUID userBadgeId, UUID userId);

  boolean existsByUserIdAndBadgeId(UUID userId, UUID badgeId);
}
