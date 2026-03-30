package com.vku.edtech.modules.badges.application.port.out;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import com.vku.edtech.modules.badges.domain.model.Badge;

public interface BadgeQueryPort {
  Optional<Badge> findById(UUID id);

  Optional<Badge> findByCode(String code);

  boolean existByCode(String code);

  List<Badge> findAll();
}
