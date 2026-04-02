package com.vku.edtech.modules.badges.application.port.in;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.vku.edtech.modules.badges.domain.model.Badge;

public interface GetAllBadgesUseCase {
  Page<Badge> getAllBadges(GetAllBadgesQuery query);

  record GetAllBadgesQuery(Pageable pageable) {
  }
}
