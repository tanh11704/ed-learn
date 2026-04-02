package com.vku.edtech.modules.badges.application.port.in;

import java.util.UUID;

import com.vku.edtech.modules.badges.domain.model.Badge;

public interface GetBadgeUseCase {
  Badge getBadge(GetBadgeQuery query);

  record GetBadgeQuery(UUID id) {
  }

}
