package com.vku.edtech.modules.badges.application.port.in;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;

public interface GetMyBadgesUseCase {
  Page<UserBadgeResult> getMyBadges(GetMyBadgesQuery query);

  record GetMyBadgesQuery(UUID userId, Pageable pageable) {
  }
}
