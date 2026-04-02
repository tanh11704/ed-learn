package com.vku.edtech.modules.badges.application.port.out;

import java.util.UUID;

import com.vku.edtech.modules.badges.domain.model.Badge;

public interface BadgeCommandPort {
  Badge save(Badge badge);

  void deleteById(UUID id);
}
