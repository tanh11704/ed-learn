package com.vku.edtech.modules.badges.application.port.in;

import java.util.List;
import java.util.UUID;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;

public interface GetMyBadgesUseCase {
  List<UserBadgeResult> getMyBadges(GetMyBadgesQuery query);

  record GetMyBadgesQuery(UUID userId) {
  }
}
